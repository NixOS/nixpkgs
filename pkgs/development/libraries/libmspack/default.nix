{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libmspack";
  version = "0.11alpha";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/libmspack/${pname}-${version}.tar.gz";
    hash = "sha256-cN0fsvCuzDZ5G3Gh4YQOYhcweeraoIEZLRwyOg7uohs=";
  };

  meta = {
    description = "A de/compression library for various Microsoft formats";
    homepage = "https://www.cabextract.org.uk/libmspack";
    license = lib.licenses.lgpl2Only;
    platforms = lib.platforms.unix;
  };
}
