{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, defusedxml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.2.6";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    sha256 = "sha256-1rr26dnV5As15HeFLWEDBDYPiRDHkGfYOYFhSJi7iyU=";
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
