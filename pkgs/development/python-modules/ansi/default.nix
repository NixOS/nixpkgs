{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98e9b27c4bb187867a69480cbc63b843331622fec7e7d090873d806e1b5d8a80";
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
