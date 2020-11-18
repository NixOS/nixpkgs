{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, defusedxml
, pytest }:

buildPythonPackage rec {
  pname = "python-didl-lite";
  version = "1.2.5";
  disabled = pythonOlder "3.5.3";

  src = fetchFromGitHub {
    owner = "StevenLooman";
    repo = pname;
    rev = version;
    sha256 = "0wm831g8k9xahw20y0461cvy6lp45sxppicxah1rg9isdc3vy3nh";
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
