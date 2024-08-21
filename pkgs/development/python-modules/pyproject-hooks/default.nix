{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pyproject-hooks,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  testpath,
  tomli,
}:

buildPythonPackage rec {
  pname = "pyproject-hooks";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi rec {
    pname = "pyproject_hooks";
    inherit version;
    hash = "sha256-8nGymLl/WVXVP7ErcsH7GUjCLBprcLMVxUztrKAmTvU=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ tomli ];

  # We need to disable tests because this package is part of the bootstrap chain
  # and its test dependencies cannot be built yet when this is being built.
  doCheck = false;

  passthru.tests = {
    pytest = buildPythonPackage {
      pname = "${pname}-pytest";
      inherit version;
      format = "other";

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

  meta = with lib; {
    description = "Low-level library for calling build-backends in `pyproject.toml`-based project";
    homepage = "https://github.com/pypa/pyproject-hooks";
    changelog = "https://github.com/pypa/pyproject-hooks/blob/v${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = teams.python.members;
  };
}
