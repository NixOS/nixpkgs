{
  fetchurl,
  stdenv,
  lib,
  pkg-config,
  boost,
  cairo,
  fontconfig,
  libsigcxx,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "cairomm";
  version = "1.14.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${version}.tar.xz";
    sha256 = "cBNiA1QMiE6Jzhye37Y2m5lTk39s1ZbZfHjJdYpdSNs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost # for tests
    fontconfig
  ];

  propagatedBuildInputs = [
    cairo
    libsigcxx
  ];

  mesonFlags = [
    "-Dbuild-tests=true"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "C++ bindings for the Cairo vector graphics library";
    homepage = "https://www.cairographics.org/";
    license = with licenses; [
      lgpl2Plus
      mpl10
    ];
    platforms = platforms.unix;
  };
}
