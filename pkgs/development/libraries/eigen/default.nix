{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "eigen";
  version = "3.4.0-unstable-2022-05-19";

  src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "e7248b26a1ed53fa030c5c459f7ea095dfd276ac";
    hash = "sha256-uQ1YYV3ojbMVfHdqjXRyUymRPjJZV3WHT36PTxPRius=";
  };

  patches = [
    ./include-dir.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://eigen.tuxfamily.org";
    description = "C++ template library for linear algebra: vectors, matrices, and related algorithms";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [
      sander
      raskin
    ];
    platforms = platforms.unix;
  };
}
