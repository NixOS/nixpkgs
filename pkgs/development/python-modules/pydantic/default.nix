{
  stdenv,
  lib,
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
  pydantic-docs,
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
  hypothesis,
  inline-snapshot,
  jsonschema,
  pytestCheckHook,
  pytest-mock,
  pytest-run-parallel,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "2.13.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-G4Xo6BF6tOn4g/qG3RNDP3/+lYnCOuw3AB1OrVOGcSA=";
  };

  patches = [
    (fetchpatch {
      name = "pytest-9.1-compat.patch";
      url = "https://github.com/pydantic/pydantic/commit/f257d0155c6643fbda9516af6b2c4ca082ed7651.patch";
      excludes = [ "uv.lock" ];
      hash = "sha256-azclSDYY/H8RcerNvI07njwLzr8fyIZ17nM18y/edVo=";
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
    hypothesis
    (inline-snapshot.overridePythonAttrs { doCheck = false; })
    jsonschema
    pytest-mock
    pytest-run-parallel
    pytest-timeout
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "tests/benchmarks"
    "tests/pydantic_core/benchmarks"

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
        pydantic-docs
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
      patchPhase = ''
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
