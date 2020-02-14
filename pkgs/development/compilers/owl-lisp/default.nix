{ stdenv, fetchFromGitLab, coreutils, which }:

stdenv.mkDerivation rec {
  pname = "owl-lisp";
  version = "0.1.19";

  src = fetchFromGitLab {
    owner  = "owl-lisp";
    repo   = "owl";
    rev    = "v${version}";
    sha256 = "1bgjd2gkr5risfcc401rlr5fc82gwm4r2gpp9gzkg9h64acivkjx";
  };

  nativeBuildInputs = [ which ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr $out
  '';

  # tests are run as part of the compilation process
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A functional Scheme for world domination";
    homepage    = "https://gitlab.com/owl-lisp/owl";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.linux;
  };
}
