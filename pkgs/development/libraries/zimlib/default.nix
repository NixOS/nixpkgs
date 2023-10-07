{ lib, stdenv, fetchFromGitHub, fetchzip
, meson, ninja, pkg-config
, python3
, icu
, libuuid
, xapian
, xz
, zstd
, gtest
}:

stdenv.mkDerivation rec {
  pname = "zimlib";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    rev = version;
    sha256 = "sha256-ab7UUF+I0/xaGChvdjylEQRHLOjmtg/wk+/JEGehGLE=";
  };

  testData = fetchzip rec {
    passthru.version = "0.4";
    url = "https://github.com/openzim/zim-testing-suite/releases/download/v${passthru.version}/zim-testing-suite-${passthru.version}.tar.gz";
    sha256 = "sha256-2eJqmvs/GrvOD/pq8dTubaiO9ZpW2WqTNQByv354Z0w=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    python3
  ];

  propagatedBuildInputs = [
    icu
    libuuid
    xapian
    xz
    zstd
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  mesonFlags = [  "-Dtest_data_dir=${testData}" ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for reading and writing ZIM files";
    homepage =  "https://www.openzim.org/wiki/Zimlib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ greg ];
    platforms = platforms.linux;
  };
}
