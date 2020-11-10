{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, defusedxml
, pytest }:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.2.4";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    sha256 = "0jf1d5m4r8qd3pn0hh1xqbkblkx9wzrrcmk7qa7q8lzfysp4z217";
  };

  propagatedBuildInputs = [
    defusedxml
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "DIDL-Lite (Digital Item Declaration Language) tools for Python";
    homepage = "https://github.com/StevenLooman/python-didl-lite";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
