{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # tests
  pretend,
  pytestCheckHook,
}:

let
  packaging = buildPythonPackage rec {
    pname = "packaging";
    version = "26.1";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-8EIVK2gcS/rFyuJ0KlXhA9J6suwPPYgDcTa2v+fJxd4=";
    };

    nativeBuildInputs = [ flit-core ];

    nativeCheckInputs = [
      pytestCheckHook
      pretend
    ];

    pythonImportsCheck = [
      "packaging"
      "packaging.metadata"
      "packaging.requirements"
      "packaging.specifiers"
      "packaging.tags"
      "packaging.version"
    ];

    # Prevent circular dependency with pytest
    doCheck = false;

    passthru.tests = packaging.overridePythonAttrs (_: {
      doCheck = true;
    });

    meta = {
      changelog = "https://github.com/pypa/packaging/blob/${version}/CHANGELOG.rst";
      description = "Core utilities for Python packages";
      downloadPage = "https://github.com/pypa/packaging";
      homepage = "https://packaging.pypa.io/";
      license = with lib.licenses; [
        bsd2
        asl20
      ];
      maintainers = with lib.maintainers; [ bennofs ];
      teams = [ lib.teams.python ];
    };
  };
in
packaging
