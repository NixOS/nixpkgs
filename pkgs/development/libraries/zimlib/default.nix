{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  python3,
  icu,
  libuuid,
  xapian,
  xz,
  zstd,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "zimlib";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    rev = version;
    hash = "sha256-yWnW/+CaQwbemrNLzvQpXw5yvW2Q6LtwDgvA58+fVUs=";
  };

  testData = fetchzip rec {
    passthru.version = "0.5";
    url = "https://github.com/openzim/zim-testing-suite/releases/download/v${passthru.version}/zim-testing-suite-${passthru.version}.tar.gz";
    hash = "sha256-hCIFT1WPDjhoZMlsR2cFbt4NhmIJ4DX1H/tDCIv4NjQ=";
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

  mesonFlags = [ "-Dtest_data_dir=${testData}" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isGNU) [
      "-Wno-error=mismatched-new-delete"
    ]
  );

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for reading and writing ZIM files";
    homepage = "https://www.openzim.org/wiki/Zimlib";
    license = licenses.gpl2;
    maintainers = with maintainers; [ greg ];
    platforms = platforms.linux;
  };
}
