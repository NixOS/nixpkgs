{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  pythonOlder,
  twine,
}:

buildPythonPackage rec {
  pname = "nagiosplugin";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vOr67DWfAyOT3dVgrizI0WNhODPsY8k85xifhZBOU9Y=";
  };

  nativeBuildInputs = [ twine ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # Test relies on who, which does not work in the sandbox
    "test_check_users"
  ];

  pythonImportsCheck = [ "nagiosplugin" ];

  meta = with lib; {
    description = "Python class library which helps with writing Nagios (Icinga) compatible plugins";
    homepage = "https://github.com/mpounsett/nagiosplugin";
    license = licenses.zpl21;
    maintainers = with maintainers; [ symphorien ];
  };
}
