{ stdenv, fetchFromGitHub, pkgconfig, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libgdiplus";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "libgdiplus";
    rev = version;
    sha256 = "1pf3yhwq9qk0w3yv9bb8qlwwqkffg7xb4sgc8yqdnn6pa56i3vmn";
  };

  NIX_LDFLAGS = "-lgif";

  outputs = [ "out" "dev" ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags = stdenv.lib.optional stdenv.cc.isClang "--host=${stdenv.hostPlatform.system}";

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
