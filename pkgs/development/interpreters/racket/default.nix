{ stdenv, fetchurl, makeFontsConf
, cacert
, cairo, coreutils, fontconfig, freefont_ttf
, glib, gmp
, gtk3
, libedit, libffi
, libiconv
, libGL
, libGLU
, libjpeg
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

  libPath = stdenv.lib.makeLibraryPath [
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
  version = "7.8"; # always change at once with ./minimal.nix

  src = (stdenv.lib.makeOverridable ({ name, sha256 }:
    fetchurl {
      url = "https://mirror.racket-lang.org/installers/${version}/${name}-src.tgz";
      inherit sha256;
    }
  )) {
    name = "${pname}-${version}";
    sha256 = "19z3dayybcra277s4gk2mppalwawd93f2b16xyrb6d7rbbfz7j9j";
  };

  FONTCONFIG_FILE = fontsConf;
  LD_LIBRARY_PATH = libPath;
  NIX_LDFLAGS = stdenv.lib.concatStringsSep " " [
    (stdenv.lib.optionalString (stdenv.cc.isGNU && ! stdenv.isDarwin) "-lgcc_s")
    (stdenv.lib.optionalString stdenv.isDarwin "-framework CoreFoundation")
  ];

  nativeBuildInputs = [ cacert wrapGAppsHook ];

  buildInputs = [ fontconfig libffi libtool sqlite gsettings-desktop-schemas gtk3 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv CoreFoundation ];

  preConfigure = ''
    unset AR
    for f in src/lt/configure src/cs/c/configure src/racket/src/string.c; do
      substituteInPlace "$f" --replace /usr/bin/uname ${coreutils}/bin/uname
    done
    mkdir src/build
    cd src/build

    gappsWrapperArgs+=("--prefix" "LD_LIBRARY_PATH" ":" ${LD_LIBRARY_PATH})
  '';

  shared = if stdenv.isDarwin then "dylib" else "shared";
  configureFlags = [ "--enable-${shared}"  "--enable-lt=${libtool}/bin/libtool" ]
                   ++ stdenv.lib.optional disableDocs [ "--disable-docs" ]
                   ++ stdenv.lib.optional stdenv.isDarwin [ "--enable-xonx" ];

  configureScript = "../configure";

  enableParallelBuilding = false;


  meta = with stdenv.lib; {
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
    broken = stdenv.isDarwin; # No support yet for setting FFI lookup path
  };
}
