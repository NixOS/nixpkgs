{ lib
, stdenv
, fetchFromGitLab
, cmake
}:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.3.7";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = pname;
    rev = version;
    hash = "sha256-oXJ4V5rakL9EPtQF0Geptl0HMR8700FdSrOB09DbbMQ=";
  };

  patches = [
    ./include-dir.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sander raskin ];
    platforms = platforms.unix;
  };
}
