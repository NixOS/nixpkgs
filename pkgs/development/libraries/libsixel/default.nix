{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gdk-pixbuf,
  gd,
  libjpeg,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "libsixel";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "libsixel";
    repo = "libsixel";
    rev = "v${version}";
    sha256 = "1nny4295ipy4ajcxmmh04c796hcds0y7z7rv3qd17mj70y8j0r2d";
  };

  buildInputs = [
    gdk-pixbuf
    gd
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
