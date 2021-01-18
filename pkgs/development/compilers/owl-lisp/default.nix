{ stdenv, fetchFromGitLab, coreutils, which }:

stdenv.mkDerivation rec {
  pname = "owl-lisp";
  version = "0.1.23";

  src = fetchFromGitLab {
    owner  = "owl-lisp";
    repo   = "owl";
    rev    = "v${version}";
    sha256 = "1indcbicqcdlk9sinkdyhk50fi1b4cb7yrr14vr874gjzmwr2l3i";
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
