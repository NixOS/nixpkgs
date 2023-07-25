{ lib, stdenv, fetchFromGitLab, which }:

stdenv.mkDerivation rec {
  pname = "owl-lisp";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner  = "owl-lisp";
    repo   = "owl";
    rev    = "v${version}";
    sha256 = "sha256-TQOj3DYmzFT4ClZ/sBAOs5XJWRgGTaVQjH+8JotSb1A=";
  };

  nativeBuildInputs = [ which ];

  makeFlags = [ "PREFIX=${placeholder "out"}" "CC=${stdenv.cc.targetPrefix}cc" ];

  # tests are run as part of the compilation process
  doCheck = false;

  meta = with lib; {
    description = "A functional Scheme for world domination";
    homepage    = "https://gitlab.com/owl-lisp/owl";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
