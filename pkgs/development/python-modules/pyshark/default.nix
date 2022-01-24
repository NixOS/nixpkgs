{ lib, buildPythonPackage, fetchFromGitHub, py, lxml, pytestCheckHook, wireshark-cli }:

buildPythonPackage rec {
  pname = "pyshark";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "KimiNewt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cveiFkkSplfQPgUEVWyV40KKHCtKJZsfvdV8JmEUmE4=";
  };

  propagatedBuildInputs = [
    py
    lxml
  ];

  preConfigure = ''
    cd src
  '';

  preCheck = ''
    cd ..
  '';

  checkInputs = [
    pytestCheckHook
    wireshark-cli
  ];

  pythonImportsCheck = [ "pyshark" ];

  meta = with lib; {
    description = "Python wrapper for tshark, allowing python packet parsing using wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark/";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
