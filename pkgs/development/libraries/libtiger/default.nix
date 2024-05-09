{ stdenv, lib, fetchurl, autoreconfHook, pkg-config
, libkate, pango, cairo, darwin
}:

stdenv.mkDerivation rec {
  pname = "libtiger";
  version = "0.3.4";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libtiger/libtiger-${version}.tar.gz";
    sha256 = "0rj1bmr9kngrgbxrjbn4f4f9pww0wmf6viflinq7ava7zdav4hkk";
  };

  patches = [
    ./pkg-config.patch
  ];

  postPatch = ''
    substituteInPlace configure.ac --replace "-Werror" "-Wno-error"
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
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
