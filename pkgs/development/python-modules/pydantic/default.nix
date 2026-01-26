{
  stdenv,
  lib,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # documentation
  autoflake,
  beautifulsoup4,
  build,
  mike,
  mkdocs,
  mkdocs-exclude,
  mkdocs-material,
  mkdocs-redirects,
  mkdocstrings,
  mkdocstrings-python,
  pydantic-extra-types,
  pydantic-settings,
  pyupgrade,
  ruff,
  tomli,
  pydantic,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  annotated-types,
  pydantic-core,
  typing-extensions,
  typing-inspection,

  # tests
  cloudpickle,
  email-validator,
  dirty-equals,
  jsonschema,
  pytestCheckHook,
  pytest-mock,
  pytest-run-parallel,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-CHJahAgs+vQQzhIZjP+6suvbmRrGZI0H5UxoXg4I90o=";
  };

  patches = lib.optionals (lib.versionAtLeast python.version "3.14.1") [
    # Fix build with python 3.14.1
    (fetchpatch {
      url = "https://github.com/pydantic/pydantic/commit/53cb5f830207dd417d20e0e55aab2e6764f0d6fc.patch";
      hash = "sha256-Y1Ob1Ei0rrw0ua+0F5L2iE2r2RdpI9DI2xuiu9pLr5Y=";
    })
  ];

  postPatch = ''
    sed -i "/--benchmark/d" pyproject.toml
  '';

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    annotated-types
    pydantic-core
    typing-extensions
    typing-inspection
  ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    cloudpickle
    dirty-equals
    jsonschema
    pytest-mock
    pytest-run-parallel
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"

    # avoid cyclic dependency
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "pydantic" ];

  passthru = {
    # Can't build the documentation as output of the main derivation, since
    # "mkdocstrings-python" indirectly depends on pydantic, causing infinite
    # recursion.
    #
    # Adjust "name" output derivation to replicate look-and-feel of "doc" output,
    # though.
    doc = stdenv.mkDerivation {
      inherit (pydantic) src version;
      name = "${pydantic.name}-doc";

      nativeBuildInputs = [
        autoflake
        beautifulsoup4
        build
        mike
        mkdocs
        mkdocs-exclude
        mkdocs-material
        mkdocs-material.optional-dependencies.imaging
        mkdocs-redirects
        mkdocstrings
        mkdocstrings-python
        pydantic
        pydantic-core
        pydantic-extra-types
        pydantic-settings
        python
        pyupgrade
        ruff
        tomli
      ];

      #  * Patch-out LLM plugin for mkdocs which is not packaged in nixpkgs.
      #  * Patch-out social plugin that tries to download fonts from goodle.
      #  * Patch upstream build system to get "pydantic-settings" documentation
      #    from the source of another package, and not from github.
      postPatch = ''
        awk '/^-/         { skip = 0 }
             /^- social/  { skip = 1 }
             /^- llmstxt/ { skip = 1 }
                          { if (!skip) print; }
        ' mkdocs.yml > mkdocs.yml~
        mv mkdocs.yml~ mkdocs.yml
        cat << EOF >> docs/plugins/main.py
        def render_pydantic_settings(markdown: str, page: Page) -> str | None:
            if page.file.src_uri != 'concepts/pydantic_settings.md':
                return None
            with open("${pydantic-settings.src}/docs/index.md") as fp:
                return re.sub(r'{{ *pydantic_settings *}}', fp.read(), markdown)
        EOF
      '';

      buildPhase = ''
        mkdocs build --no-strict
      '';

      # Follow the "sphinxHook" conventions.
      installPhase = ''
        mkdir -p $out/share/doc
        cp -r ./site $out/share/doc/${pydantic.name}
      '';
    };
  };

  meta = {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wd15 ];
  };
}
