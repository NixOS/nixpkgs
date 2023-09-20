{ fetchurl
, stdenv
, lib
, pkg-config
, darwin
, cairo
, fontconfig
, freetype
, libsigcxx
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "cairomm";
  version = "1.14.4";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${version}.tar.xz";
    sha256 = "R0nSWisu9nzAwBTKr1yH+kZ5L8Sz7eGG+w/JMtIFUVg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
  ]);

  propagatedBuildInputs = [
    cairo
    libsigcxx
  ];

  doCheck = true;

  meta = with lib; {
    description = "A 2D graphics library with support for multiple output devices";

    longDescription = ''
      Cairo is a 2D graphics library with support for multiple output
      devices.  Currently supported output targets include the X
      Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.  Experimental backends include OpenGL
      (through glitz), XCB, BeOS, OS/2, and DirectFB.

      Cairo is designed to produce consistent output on all output
      media while taking advantage of display hardware acceleration
      when available (e.g., through the X Render Extension).
    '';

    homepage = "https://www.cairographics.org/";

    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.unix;
  };
}
