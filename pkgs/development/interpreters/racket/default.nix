{ lib, stdenv, fetchurl, makeFontsConf
, cacert
, cairo, coreutils, fontconfig, freefont_ttf
, glib, gmp
, gtk3
, libedit, libffi
, libiconv
, libGL
, libGLU
, libjpeg
, xorg
, ncurses
, libpng, libtool, mpfr, openssl, pango, poppler
, readline, sqlite
, disableDocs ? false
, CoreFoundation
, gsettings-desktop-schemas
, wrapGAppsHook
}:

let

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  libPath = lib.makeLibraryPath [
    cairo
    fontconfig
    glib
    gmp
    gtk3
    gsettings-desktop-schemas
    libedit
    libGL
    libGLU
    libjpeg
    libpng
    mpfr
    ncurses
    openssl
    pango
    poppler
    readline
    sqlite
  ];

in

stdenv.mkDerivation rec {
  pname = "racket";
  version = "8.6"; # always change at once with ./minimal.nix

  src = (lib.makeOverridable ({ name, sha256 }:
    fetchurl {
      url = "https://mirror.racket-lang.org/installers/${version}/${name}-src.tgz";
      inherit sha256;
    }
  )) {
    name = "${pname}-${version}";
    sha256 = "sha256-Lv8+l7x6EM+gMg2psH8NSIZTsLW4SQMiyC84SuD6Gig=";
  };

  FONTCONFIG_FILE = fontsConf;
  LD_LIBRARY_PATH = libPath;
  NIX_LDFLAGS = lib.concatStringsSep " " [
    (lib.optionalString (stdenv.cc.isGNU && ! stdenv.isDarwin) "-lgcc_s")
  ];

  nativeBuildInputs = [ cacert wrapGAppsHook ];

  buildInputs = [ fontconfig libffi libtool sqlite gsettings-desktop-schemas gtk3 ncurses ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreFoundation ];

  patches = [
    # Hardcode variant detection because we wrap the Racket binary making it
    # fail to detect its variant at runtime.
    # See: https://github.com/NixOS/nixpkgs/issues/114993#issuecomment-812951247
    ./force-cs-variant.patch

    # The entry point binary $out/bin/racket is codesigned at least once. The
    # following error is triggered as a result.
    # (error 'add-ad-hoc-signature "file already has a signature")
    # We always remove the existing signature then call add-ad-hoc-signature to
    # circumvent this error.
    ./force-remove-codesign-then-add.patch
  ];

  preConfigure = ''
    unset AR
    for f in src/lt/configure src/cs/c/configure src/bc/src/string.c; do
      substituteInPlace "$f" \
        --replace /usr/bin/uname ${coreutils}/bin/uname \
        --replace /bin/cp ${coreutils}/bin/cp \
        --replace /bin/ln ${coreutils}/bin/ln \
        --replace /bin/rm ${coreutils}/bin/rm \
        --replace /bin/true ${coreutils}/bin/true
    done

    # The configure script forces using `libtool -o` as AR on Darwin. But, the
    # `-o` option is only available from Apple libtool. GNU ar works here.
    substituteInPlace src/ChezScheme/zlib/configure \
        --replace 'ARFLAGS="-o"' 'AR=ar; ARFLAGS="rc"'

    mkdir src/build
    cd src/build

  '' + lib.optionalString stdenv.isLinux ''
    gappsWrapperArgs+=("--prefix"   "LD_LIBRARY_PATH" ":" ${libPath})
  '' + lib.optionalString stdenv.isDarwin ''
    gappsWrapperArgs+=("--prefix" "DYLD_LIBRARY_PATH" ":" ${libPath})
  ''
  ;

  preBuild = lib.optionalString stdenv.isDarwin ''
    # Cannot set DYLD_LIBRARY_PATH as an attr of this drv, becasue dynamic
    # linker environment variables like this are purged.
    # See: https://apple.stackexchange.com/a/212954/167199

    # Make builders feed it to dlopen(...). Do not expose all of $libPath to
    # DYLD_LIBRARY_PATH as the order of looking up symbols like
    # `__cg_jpeg_resync_to_restart` will be messed up. Our libJPEG.dyllib
    # expects it from our libTIFF.dylib, but instead it could not be found from
    # the system `libTIFF.dylib`. DYLD_FALLBACK_LIBRARY_PATH has its own problem
    # , too.
    export DYLD_FALLBACK_LIBRARY_PATH="${libPath}"
  '';

  shared = if stdenv.isDarwin then "dylib" else "shared";
  configureFlags = [ "--enable-${shared}"  "--enable-lt=${libtool}/bin/libtool" ]
                   ++ lib.optional disableDocs [ "--disable-docs" ]
                   ++ lib.optional stdenv.isDarwin [ "--enable-xonx" ];

  configureScript = "../configure";

  enableParallelBuilding = false;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A programmable programming language";
    longDescription = ''
      Racket is a full-spectrum programming language. It goes beyond
      Lisp and Scheme with dialects that support objects, types,
      laziness, and more. Racket enables programmers to link
      components written in different dialects, and it empowers
      programmers to create new, project-specific dialects. Racket's
      libraries support applications from web servers and databases to
      GUIs and charts.
    '';
    homepage = "https://racket-lang.org/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ henrytill vrthra ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
  };
}
