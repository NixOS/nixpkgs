{ stdenv, fetchFromGitHub, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libungif, libjpeg, libpng, monoDLLFixer
, libXrender, libexif, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libgdiplus-5.6";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "libgdiplus";
    rev = "5.6";
    sha256 = "11xr84kng74j3pd8sx74q80a71k6dw0a502qgibcxlyqh666lfb7";
  };

  NIX_LDFLAGS = "-lgif";

  patches =
    [
    ];

  patchFlags = "-p0";

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs =
    [ glib cairo fontconfig libtiff giflib libungif
      libjpeg libpng libXrender libexif
    ]
    ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
