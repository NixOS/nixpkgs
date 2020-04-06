{ stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "2.0.17";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = version;
    sha256 = "0d4knrcz04pxmxaqs5r3wv092950kl1z9wsw87vdzi9kgvc6wl0b";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = "https://eigen.tuxfamily.org";
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    branch = "2";
    platforms = with stdenv.lib.platforms; unix;
  };
}
