{ stdenv
, lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, cjson
, cmocka
, mbedtls
}:

stdenv.mkDerivation rec {
  pname = "librist";
  version = "0.2.8";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    rev = "v${version}";
    hash = "sha256-E12TS+N47UQapkF6oO0Lx66Z3lHAyP0R4tVnx/uKBwQ=";
  };

  patches = [
    # https://github.com/NixOS/nixpkgs/pull/257020
    ./darwin.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cjson
    cmocka
    mbedtls
  ];

  meta = with lib; {
    description = "A library that can be used to easily add the RIST protocol to your application.";
    homepage = "https://code.videolan.org/rist/librist";
    license = with licenses; [ bsd2 mit isc ];
    maintainers = with maintainers; [ raphaelr sebtm ];
    platforms = platforms.all;
  };
}
