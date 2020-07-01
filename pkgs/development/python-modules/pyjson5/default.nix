{ buildPythonPackage, lib, nose, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pyjson5";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "dpranke";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nyngj18jlkgvm1177lc3cj47wm4yh3dqigygvcvw7xkyryafsqn";
  };

  doCheck = true;
  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Python implementation of the JSON5 data format";
    license = licenses.asl20;
    homepage = "https://github.com/dpranke/pyjson5";
    maintainers = with maintainers; [ isgy ];
  };
}
