{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, libbsd
, gdk-pixbuf
, gd
, libjpeg
, pkg-config
, fetchpatch
}:
stdenv.mkDerivation rec {
  pname = "libsixel";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "libsixel";
    repo = "libsixel";
    rev = "v${version}";
    sha256 = "sha256-ACypJTFjXSzBjo4hQzUiJOqnaRaZnYX+/NublN9sbBo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/libsixel/libsixel/commit/4d3e53ee007f3b71f638875f9fabbba658b2ca8a.patch";
      sha256 = "sha256-iDfsTyUczjtzV3pt1ZErbhVO2rMm2ZYKWSBl+ru+5HA=";
    })
  ];

  buildInputs = [
    libbsd gdk-pixbuf gd
  ];

  nativeBuildInputs = [
    meson ninja pkg-config
  ];

  doCheck = true;

  mesonFlags = [
    "-Dtests=enabled"
    # build system seems to be broken here, it still seems to handle jpeg
    # through some other ways.
    "-Djpeg=disabled"
    "-Dpng=disabled"
  ];

  meta = with lib; {
    description = "The SIXEL library for console graphics, and converter programs";
    homepage = "https://github.com/libsixel/libsixel";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
