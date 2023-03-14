{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "zix";
  version = "unstable-2023-02-13";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = pname;
    rev = "262d4a1522c38be0588746e874159da5c7bb457d";
    hash = "sha256-3vuefgnirM4ksK3j9sjBHgOmx0JpL+6tCPb69/7jI00=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dbenchmarks=disabled"
    "-Ddocs=disabled"
  ];

  meta = with lib; {
    description = "A lightweight C99 portability and data structure library";
    homepage = "https://gitlab.com/drobilla/zix";
    changelog = "https://gitlab.com/drobilla/zix/-/blob/${src.rev}/NEWS";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      yuu
      zseri
    ];
  };
}
