{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EFRc4lCORw6SCNDMIAYWAy/cgbhJZ4gm+3yByCP9SLE=";
  };

  checkPhase = ''
    python -c "import ansi.color"
  '';

  meta = with lib; {
    description = "ANSI cursor movement and graphics";
    homepage = "https://github.com/tehmaze/ansi/";
    license = licenses.mit;
  };
}
