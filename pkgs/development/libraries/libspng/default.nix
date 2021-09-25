{ lib
, fetchFromGitHub
, stdenv
, zlib
, ninja
, meson
, pkg-config
, cmake
, libpng
}:

stdenv.mkDerivation rec {
  pname = "libspng";
  version = "0.7.0-rc3";

  src = fetchFromGitHub {
    owner = "randy408";
    repo = pname;
    rev = "v${version}";
    sha256 = "0n91mr06sr34cqq91738251iaw21h5c4jgjpn0kqfx69ywxcl9fj";
  };

  doCheck = true;

  mesonBuildType = "release";

  mesonFlags = [
    # this is required to enable testing
    # https://github.com/randy408/libspng/blob/bc383951e9a6e04dbc0766f6737e873e0eedb40b/tests/README.md#testing
    "-Ddev_build=true"
  ];

  outputs = [ "out" "dev" ];

  checkInputs = [
    cmake
    libpng
  ];

  buildInputs = [
    pkg-config
    zlib
  ];

  nativeBuildInputs = [
    ninja
    meson
  ];

  meta = with lib; {
    description = "Simple, modern libpng alternative";
    homepage = "https://github.com/randy408/libspng";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ humancalico ];
  };
}
