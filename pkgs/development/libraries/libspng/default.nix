{
  lib,
  fetchFromGitHub,
  stdenv,
  zlib,
  ninja,
  meson,
  pkg-config,
  cmake,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "libspng";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "randy408";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BiRuPQEKVJYYgfUsglIuxrBoJBFiQ0ygQmAFrVvCz4Q=";
  };

  doCheck = true;

  mesonBuildType = "release";

  mesonFlags = [
    # this is required to enable testing
    # https://github.com/randy408/libspng/blob/bc383951e9a6e04dbc0766f6737e873e0eedb40b/tests/README.md#testing
    "-Ddev_build=true"
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeCheckInputs = [
    cmake
    libpng
  ];

  buildInputs = [
    zlib
  ];

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ];

  meta = with lib; {
    description = "Simple, modern libpng alternative";
    homepage = "https://libspng.org/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ humancalico ];
    platforms = platforms.all;
  };
}
