{ buildPythonPackage
, fetchFromGitHub
, nose
, pkgs
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "8.19.10.30";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "ddcd3a60256789b0ed3302907cb798bf01b1c5e6"; # versions are only tagged on PyPi
    sha256 = "1wvqhrxynj652jpzcn1nmrbchxxwwfwqrgfwrhhynyxrw1gal84m";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests tests/
  '';

  meta = with pkgs.lib; {
    description = "A collection of classes that contain architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = licenses.bsd2;
    maintainers = [ maintainers.pamplemousse ];
  };
}
