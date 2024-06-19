{
  lib,
  stdenv,
  fetchFromGitHub,
  icu,
  meson,
  ninja,
  pkg-config,
  python3,
  xapian,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "libzim";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = "libzim";
    rev = "refs/tags/${version}";
    hash = "sha256-yxEtFsdLTcHFyoIX21nWo6gI7ERDN2/hsUHS/2mTFR4=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zstd
  ];

  propagatedBuildInputs = [
    xapian
    xz
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  mesonFlags = [
    # Tests are located at https://github.com/openzim/zim-testing-suite
    # "...some tests need up to 16GB of memory..."
    "-Dtest_data_dir=none"
  ];

  meta = with lib; {
    description = "Reference implementation of the ZIM specification";
    homepage = "https://github.com/openzim/libzim";
    changelog = "https://github.com/openzim/libzim/releases/tag/${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
