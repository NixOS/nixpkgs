{ stdenv, lib, fetchurl, libkate, pango, cairo, pkgconfig, darwin }:

stdenv.mkDerivation rec {
  name = "libtiger-0.3.4";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libtiger/${name}.tar.gz";
    sha256 = "0rj1bmr9kngrgbxrjbn4f4f9pww0wmf6viflinq7ava7zdav4hkk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libkate pango cairo ]
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.ApplicationServices;

  meta = {
    homepage = "https://code.google.com/archive/p/libtiger/";
    description = "A rendering library for Kate streams using Pango and Cairo";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ matthewbauer ];
  };
}
