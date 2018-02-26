# TODO: get rid of this (https://github.com/NixOS/nixpkgs/issues/32883)
{ stdenv, lib, fetchurl, cmake, ninja, pkgconfig, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms2, libjpeg, openjpeg
, poppler_data, qt4
}:

let
  # Last version supporting QT4
  version = "0.61.1";
in
stdenv.mkDerivation rec {
  name = "poppler-qt4-${version}";

  src = fetchurl {
    url = "${meta.homepage}/poppler-${version}.tar.xz";
    sha256 = "1afdrxxkaivvviazxkg5blsf2x24sjkfj92ib0d3q5pm8dihjrhj";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ libiconv poppler_data ] ++ libintlOrEmpty;

  propagatedBuildInputs = [ zlib freetype fontconfig libjpeg openjpeg cairo lcms2 curl qt4 ];

  nativeBuildInputs = [ cmake ninja pkgconfig ];

  cmakeFlags = [
    "-DENABLE_XPDF_HEADERS=on"
    "-DENABLE_UTILS=off"
  ];

  meta = with lib; {
    homepage = https://poppler.freedesktop.org/;
    description = "A PDF rendering library";

    longDescription = ''
      Poppler is a PDF rendering library based on the xpdf-3.0 code base.
    '';

    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
