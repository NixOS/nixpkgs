{ stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.3.7";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = version;
    sha256 = "1i3cvg8d70dk99fl3lrv3wqhfpdnm5kx01fl7r2bz46sk9bphwm1";
  };

  patches = [
    ./include-dir.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    homepage = "https://eigen.tuxfamily.org";
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ sander raskin ];
    inherit version;
  };
}
