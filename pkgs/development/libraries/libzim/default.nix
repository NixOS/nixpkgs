{ lib
, stdenv
, fetchFromGitHub
, icu
, meson
, ninja
, pkg-config
, python3
, xapian
, xz
, zstd
}:

stdenv.mkDerivation rec {
  pname = "libzim";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Xh1SQNmG4lQ3f/g+i5m36LJO9JlPzP4bNqhyyKT7NEA=";
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
