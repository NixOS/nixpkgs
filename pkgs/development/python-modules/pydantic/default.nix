{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # documentation
  autoflake,
  beautifulsoup4,
  mike,
  mkdocs,
  mkdocs-exclude,
  mkdocs-material,
  mkdocs-redirects,
  mkdocstrings,
  mkdocstrings-python,
  pydantic-extra-types,
  pydantic-settings,
  python,
  pyupgrade,
  ruff,
  tomli,

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
  pytest-codspeed,
  pytest-mock,
  pytest-run-parallel,
  eval-type-backport,
  rich,
}:
let
  version = "2.11.7";
  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "v${version}";
    hash = "sha256-5EQwbAqRExApJvVUJ1C6fsEC1/rEI6/bQEQkStqgf/Q=";
  };
  # Can't build the documentation as output of the main derivation, since
  # "mkdocstrings-python" indirectly depends on pydantic, causing infinite
  # recursion.
  #
  # Adjust "name" output derivation to replicate look-and-feel of "doc" output,
  # though.
  doc = stdenv.mkDerivation {
    inherit src version;
    name = "pydantic-${version}-doc";

    nativeBuildInputs = [
      autoflake
      beautifulsoup4
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

    # Follow the convention of the sphinxHook.
    installPhase = ''
      mkdir -p $out/share/doc
      cp -r ./site $out/share/doc/${pydantic.name}
    '';
  };

  pydantic = buildPythonPackage rec {
    inherit src version;

    pname = "pydantic";
    pyproject = true;

    disabled = pythonOlder "3.8";

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
      pytest-codspeed
      pytest-mock
      pytest-run-parallel
      pytestCheckHook
      rich
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies)
    ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ];

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    disabledTestPaths = [
      "tests/benchmarks"

      # avoid cyclic dependency
      "tests/test_docs.py"
    ];

    pythonImportsCheck = [ "pydantic" ];

    meta = with lib; {
      description = "Data validation and settings management using Python type hinting";
      homepage = "https://github.com/pydantic/pydantic";
      changelog = "https://github.com/pydantic/pydantic/blob/${src.tag}/HISTORY.md";
      license = licenses.mit;
      maintainers = with maintainers; [ wd15 ];
    };
  };
in
pydantic // { inherit doc; }
