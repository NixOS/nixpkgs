{ pkgs
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyqt5
, asyncua
}:

buildPythonPackage rec {
  pname = "opcua-widgets";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = pname;
    rev = version;
    hash = "sha256-ABJlKYN5H/1k8ynvSTSoJBX12vTTyavuNUAmTJ84mn0=";
  };

  disabled = pythonOlder "3.10";

  propagatedBuildInputs = [
    pyqt5
    asyncua
  ];

  pythonImportsCheck = [ "uawidgets" ];

  #This test is broken, when updating this package check if the test was fixed.
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Common widgets for opcua-modeler og opcua-client-gui";
    homepage = "https://github.com/FreeOpcUa/opcua-widgets";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ janik ];
  };
}
