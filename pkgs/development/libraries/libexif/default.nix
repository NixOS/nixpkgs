{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  pname = "libexif";
  version = "0.6.22";

  src = let
    underscoreVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
  in fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/${pname}-${underscoreVersion}-release/${pname}-${version}.tar.xz";
    sha256 = "0mhcad5zab7fsn120rd585h8ncwkq904nzzrq8vcd72hzk4g2j2h";
  };

  buildInputs = [ gettext ];

  meta = {
    homepage = "https://libexif.github.io/";
    description = "A library to read and manipulate EXIF data in digital photographs";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.erictapen ];
  };

}
