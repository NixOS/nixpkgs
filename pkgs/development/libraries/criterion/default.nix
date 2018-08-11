{stdenv, pkgconfig, fetchFromGitHub, cmake, dyncall, nanomsg, boxfort, csptr, libgit2} :

stdenv.mkDerivation {
  name = "criterion-2.3.2";
  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    rev = "9b70365825aced7333d7867bb5c64c63919ce510";
    sha256 = "1i1ccgrnsq8ka5a0hfipd48baya138m2v411myg6jqkhwknplzz9";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ dyncall boxfort csptr nanomsg libgit2 ];

  LIBGIT2_SYS_USE_PKG_CONFIG=1;

  meta = {
    homepage = "https://github.com/Snaipe/Criterion";
    description = "A cross-platform C and C++ unit testing framework for the 21th century";
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
