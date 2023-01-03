{ lib
, stdenv
, fetchFromGitHub
, icu
, meson
, ninja
, pkg-config
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "libzim";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ab7UUF+I0/xaGChvdjylEQRHLOjmtg/wk+/JEGehGLE=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ];

  buildInputs = [
    icu
    xz
    zstd
  ];

  mesonFlags = [
    # Tests are located at https://github.com/openzim/zim-testing-suite
    # "...some tests need up to 16GB of memory..."
    "-Dtest_data_dir=none"
    "-Dwith_xapian=false"
  ];

  meta = with lib; {
    description = "Reference implementation of the ZIM specification";
    homepage = "https://github.com/openzim/libzim";
    changelog = "https://github.com/openzim/libzim/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
