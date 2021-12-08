{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "ansi";
  version = "0.2.0";

  src = fetchFromGitHub {
     owner = "tehmaze";
     repo = "ansi";
     rev = "ansi-0.2.0";
     sha256 = "05ic2kf8bazj9f0yk63ifs3ap0y1naqn1y44z0w1z65phi9vay81";
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
