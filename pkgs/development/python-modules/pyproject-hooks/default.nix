{ lib
, buildPythonPackage
, fetchPypi

# build
, flit-core
, installer
, python

# tests
, pytestCheckHook
, pythonOlder
, setuptools
, testpath
, tomli
}:

buildPythonPackage rec {
  pname = "pyproject-hooks";
  version = "1.0.0";
  format = "other";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyproject_hooks";
    inherit version;
    hash = "sha256-8nGymLl/WVXVP7ErcsH7GUjCLBprcLMVxUztrKAmTvU=";
  };

  nativeBuildInputs = [
    flit-core
    installer
  ];

  propagatedBuildInputs = [
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  buildPhase = ''
    runHook preBuild
    ${python.interpreter} -m flit_core.wheel
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python.interpreter} -m installer --prefix "$out" dist/*.whl
    runHook postInstall
  '';

  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
    testpath
  ];

  disabledTests = [
    # fail to import setuptools
    "test_setup_py"
    "test_issue_104"
  ];

  pythonImportsCheck = [
    "pyproject_hooks"
  ];

  meta = with lib; {
    description = "Low-level library for calling build-backends in `pyproject.toml`-based project ";
    homepage = "https://github.com/pypa/pyproject-hooks";
    changelog = "https://github.com/pypa/pyproject-hooks/blob/v${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = teams.python.members;
  };
}
