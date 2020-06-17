{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02sknsbx55r6nylznslmmzzkfi3rsw7akpyzi6f1bqvr2ila8p0f";
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
