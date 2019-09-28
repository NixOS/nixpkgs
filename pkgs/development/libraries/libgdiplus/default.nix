{ stdenv, fetchFromGitHub, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libgdiplus";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "libgdiplus";
    rev = version;
    sha256 = "07a3n7i35mn5j2djah64by785b1hzy8ckk1pz0xwvk716yzb7sxg";
  };

  NIX_LDFLAGS = "-lgif";

  outputs = [ "out" "dev" ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs =
    [ glib cairo fontconfig libtiff giflib
      libjpeg libpng libXrender libexif
    ]
    ++ stdenv.lib.optional stdenv.isDarwin Carbon;

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  checkPhase = ''
    make check -w
  '';

  meta = with stdenv.lib; {
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = https://www.mono-project.com/docs/gui/libgdiplus/;
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
