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
  version = "0.2.7";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "rist";
    repo = "librist";
    rev = "v${version}";
    sha256 = "sha256-qQG2eRAPAQgxghMeUZk3nwyacX6jDl33F8BWW63nM3c=";
  };

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
