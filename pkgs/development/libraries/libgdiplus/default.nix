<<<<<<< HEAD
{ lib, stdenv, fetchzip, pkg-config, glib, cairo, Carbon, fontconfig
, libtiff, giflib, libjpeg, libpng
, libXrender, libexif, autoreconfHook, fetchpatch }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgdiplus";
  version = "6.1";

  # Using source archive to avoid fetching Git submodules.
  # Git repo: https://github.com/mono/libgdiplus
  src = fetchzip {
    url = "https://download.mono-project.com/sources/libgdiplus/libgdiplus-${finalAttrs.version}.tar.gz";
    hash = "sha256-+lP9ETlw3s0RUliQT1uBWZ2j6o3V9EECBQSppOYFq4Q=";
  };

  patches = [
    # Fix pkg-config lookup when cross-compiling.
    ./configure-pkg-config.patch
  ];

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
