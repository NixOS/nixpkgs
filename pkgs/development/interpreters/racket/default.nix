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
    openssl
    pango
    poppler
    readline
    sqlite
  ];

in

stdenv.mkDerivation rec {
  pname = "racket";
  version = "8.2"; # always change at once with ./minimal.nix

  src = (lib.makeOverridable ({ name, sha256 }:
    fetchurl {
      url = "https://mirror.racket-lang.org/installers/${version}/${name}-src.tgz";
      inherit sha256;
    }
  )) {
    name = "${pname}-${version}";
    sha256 = "10kl9xxl9swz8hdpycpy1vjc8biah5h07dzaygsf0ylfjdrczwx0";
  };

  FONTCONFIG_FILE = fontsConf;
  LD_LIBRARY_PATH = libPath;
  NIX_LDFLAGS = lib.concatStringsSep " " [
    (lib.optionalString (stdenv.cc.isGNU && ! stdenv.isDarwin) "-lgcc_s")
    (lib.optionalString stdenv.isDarwin "-framework CoreFoundation")
  ];

  nativeBuildInputs = [ cacert wrapGAppsHook ];

  buildInputs = [ fontconfig libffi libtool sqlite gsettings-desktop-schemas gtk3 ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreFoundation ncurses ];

  patches = [
    # Hardcode variant detection because we wrap the Racket binary making it
    # fail to detect its variant at runtime.
    # See: https://github.com/NixOS/nixpkgs/issues/114993#issuecomment-812951247
    ./force-cs-variant.patch
  ];

  preConfigure = ''
    unset AR
    for f in src/lt/configure src/cs/c/configure src/bc/src/string.c src/ChezScheme/workarea; do
      substituteInPlace "$f" \
        --replace /usr/bin/uname ${coreutils}/bin/uname \
        --replace /bin/cp ${coreutils}/bin/cp \
        --replace /bin/ln ${coreutils}/bin/ln \
        --replace /bin/rm ${coreutils}/bin/rm \
        --replace /bin/true ${coreutils}/bin/true
    done
    mkdir src/build
    cd src/build

    gappsWrapperArgs+=("--prefix" "LD_LIBRARY_PATH" ":" ${LD_LIBRARY_PATH})
  '';

  shared = if stdenv.isDarwin then "dylib" else "shared";
  configureFlags = [ "--enable-${shared}"  "--enable-lt=${libtool}/bin/libtool" ]
                   ++ lib.optional disableDocs [ "--disable-docs" ]
                   ++ lib.optional stdenv.isDarwin [ "--enable-xonx" ];

  configureScript = "../configure";

  enableParallelBuilding = false;

  meta = with lib; {
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
    maintainers = with maintainers; [ kkallio henrytill vrthra ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
  };
}
