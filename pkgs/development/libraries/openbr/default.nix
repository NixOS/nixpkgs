{ lib, stdenv, fetchFromGitHub, cmake, opencv, qtbase, qtsvg }:

stdenv.mkDerivation {

  version = "0.5";
  pname = "openbr";

  src = fetchFromGitHub {
    owner = "biometrics";
    repo = "openbr";
    rev = "cc364a89a86698cd8d3052f42a3cb520c929b325";
    sha256 = "12y00cf5dlzp9ciiwbihf6xhlkdxpydhscv5hwp83qjdllid9rrz";
  };

  buildInputs = [ opencv qtbase qtsvg ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Open Source Biometric Recognition";
    homepage = "http://openbiometrics.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [flosse];
    platforms = with lib.platforms; linux;
    broken = true;
  };
}
