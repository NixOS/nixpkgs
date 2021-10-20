{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, defusedxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.3.0";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    sha256 = "sha256-NsZ/VQlKEp4p3JRSNQKTGvzLrKgDCkkT81NzgS3UHos=";
  };

  propagatedBuildInputs = [
    defusedxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "didl_lite" ];

  meta = with lib; {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
