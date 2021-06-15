{ lib, stdenv, fetchFromGitHub, pkg-config, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif, autoreconfHook, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libgdiplus";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "libgdiplus";
    rev = version;
    sha256 = "1387lgph5r17viv3rkf5hbksdn435njzmra7s17q0nzk2mkkm68c";
  };

  NIX_LDFLAGS = "-lgif";

  outputs = [ "out" "dev" ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  configureFlags = lib.optional stdenv.cc.isClang "--host=${stdenv.hostPlatform.system}";

  enableParallelBuilding = true;

  buildInputs =
    [ glib cairo fontconfig libtiff giflib
      libjpeg libpng libXrender libexif
    ]
    ++ lib.optional stdenv.isDarwin Carbon;

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/libgdiplus.0.dylib $out/lib/libgdiplus.so
  '';

  checkPhase = ''
    make check -w
  '';

  meta = with lib; {
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = "https://www.mono-project.com/docs/gui/libgdiplus/";
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
