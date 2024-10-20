{
  lib,
  buildPythonPackage,
  fetchPypi,
  decorator,
  deprecated,
  icecream,
  invocations,
  invoke,
  paramiko,
  pynacl,
  pypaInstallHook,
  pytest-cov,
  pytest-relaxed,
  pytestCheckHook,
  setuptoolsBuildHook,
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "3.2.2";
  pyproject = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h4PKQuOwB28IsmkBqsa52bHxnEEAdOesz6uQLBhP9KM=";
  };

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = [
    decorator
    deprecated
    invoke
    paramiko
    pynacl
  ];

  nativeCheckInputs = [
    icecream
    invocations
    pytest-cov
    pytest-relaxed
    pytestCheckHook
  ];

  # distutils.errors.DistutilsArgError: no commands supplied
  doCheck = false;

  pythonImportsCheck = [ "fabric" ];

  meta = {
    description = "Pythonic remote execution";
    homepage = "http://fabfile.org/";
    changelog = "https://www.fabfile.org/changelog.html";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "fab";
  };
}
