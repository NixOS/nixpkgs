{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06y6470bzvlqys3zi2vc68rmk9n05v1ibral14gbfpgfa8fzy7pg";
  };

  checkPhase = ''
    python -c "import ansi.color"
  '';

  meta = with lib; {
    description = "ANSI cursor movement and graphics";
    homepage = https://github.com/tehmaze/ansi/;
    license = licenses.mit;
  };
}
