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
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "openzim";
    repo = pname;
    rev = version;
    sha256 = "sha256-8mKUYvw/0aqrerNNKk0V7r5LByEaaJLg43R/0pwM4Z8=";
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
