{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pyproject-hooks,
  pytestCheckHook,
  setuptools,
  testpath,
}:

buildPythonPackage rec {
  pname = "pyproject-hooks";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyproject_hooks";
    inherit version;
    hash = "sha256-HoWb1cQPrpRIZC3Yca30WeXiCEGG6NLCp5qCTJcNofg=";
  };

  nativeBuildInputs = [ flit-core ];

  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      pyproject = false;

      dontBuild = true;
      dontInstall = true;

      nativeCheckInputs = [
        pyproject-hooks
        pytestCheckHook
        setuptools
        testpath
      ];

      disabledTests = [
        # fail to import setuptools
        "test_setup_py"
        "test_issue_104"
      ];
    };
  };

  pythonImportsCheck = [ "pyproject_hooks" ];

  meta = {
    description = "Low-level library for calling build-backends in `pyproject.toml`-based project";
    homepage = "https://github.com/pypa/pyproject-hooks";
    changelog = "https://github.com/pypa/pyproject-hooks/blob/v${version}/docs/changelog.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.python ];
  };
}
