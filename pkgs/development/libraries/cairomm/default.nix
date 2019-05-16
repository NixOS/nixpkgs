{ fetchurl, stdenv, pkgconfig, darwin, cairo, fontconfig, freetype, libsigcxx }:
let
  ver_maj = "1.12";
  ver_min = "2";
in
stdenv.mkDerivation rec {
  name = "cairomm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "https://www.cairographics.org/releases/${name}.tar.gz";
    # gnome doesn't have the latest version ATM; beware: same name but different hash
    # url = "mirror://gnome/sources/cairomm/${ver_maj}/${name}.tar.xz";
    sha256 = "16fmigxsaz85c3lgcls7biwyz8zy8c8h3jndfm54cxxas3a7zi25";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ cairo libsigcxx ];
  buildInputs = [ fontconfig freetype ]
  ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
  ]);

  doCheck = true;

  meta = with stdenv.lib; {
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

    homepage = http://cairographics.org/;

    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.unix;
  };
}
