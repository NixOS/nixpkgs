{ stdenv, fetchurl, fetchpatch, pkgconfig, cmake, libiconv, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, qt4Support ? false, qt4 ? null, qt5
}:

let
  version = "0.28.1"; # even major numbers are stable
  sha256 = "01pxjdbhvpxf00ncf8d9wxc8gkcqcxz59lwrpa151ah988inxkrc";

  # This is for Okular (and similar) to support subpixel rendering.
  # It's kept from upstream because of political reasons.
  qtcairo_patch = fetchpatch {
    url = "https://github.com/giddie/poppler-qt4-cairo-backend/compare/"
      + "fa1d636...b30f96c.diff"; # update to current maint...qt4-lcd
    sha256 = "0g18y247k2vcz1n56rnfpy226f22v4r9c7pk8cf2h9l12vz2qxkm";
  };

  poppler_drv = nameSuff: merge: stdenv.mkDerivation (stdenv.lib.mergeAttrsByFuncDefaultsClean [
  rec {
    name = "poppler-${nameSuff}-${version}";

    src = fetchurl {
      url = "${meta.homepage}/poppler-${version}.tar.xz";
      inherit sha256;
    };

    propagatedBuildInputs = [ zlib cairo freetype fontconfig libjpeg lcms curl openjpeg ];

    nativeBuildInputs = [ pkgconfig cmake libiconv ] ++ libintlOrEmpty;

    cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

    patches = [ ./datadir_env.patch ./poppler-glib.patch ];

    # XXX: The Poppler/Qt4 test suite refers to non-existent PDF files
    # such as `../../../test/unittestcases/UseNone.pdf'.
    #doCheck = !qt4Support;
    checkTarget = "test";

    enableParallelBuilding = true;

    meta = {
      homepage = http://poppler.freedesktop.org/;
      description = "A PDF rendering library";

      longDescription = ''
        Poppler is a PDF rendering library based on the xpdf-3.0 code base.
      '';

      license = stdenv.lib.licenses.gpl2;
      platforms = stdenv.lib.platforms.all;
    };
  } merge ]); # poppler_drv

  /* We always use cairo in poppler, so we always depend on glib,
     so we always build the glib wrapper (~350kB).
     We also always build the cpp wrapper (<100kB).
     ToDo: around half the size could be saved by splitting out headers and tools (1.5 + 0.5 MB).
  */

  poppler_glib = poppler_drv "glib" { };

  poppler_qt4 = poppler_drv "qt4" {
    #patches = [ qtcairo_patch ]; # text rendering artifacts in recent versions
    propagatedBuildInputs = [ qt4 poppler_glib ];
    NIX_LDFLAGS = "-lpoppler";
    postConfigure = ''
      mkdir -p "$out/lib/pkgconfig"
      install -c -m 644 poppler-qt4.pc "$out/lib/pkgconfig"
      cd qt4
    '';
  };

  poppler_qt5 = poppler_drv "qt5" {
    propagatedBuildInputs = [ qt5.base poppler_glib ];
    postConfigure = ''
      mkdir -p "$out/lib/pkgconfig"
      install -c -m 644 poppler-qt5.pc "$out/lib/pkgconfig"
      cd qt5
    '';
  };

in { inherit poppler_glib poppler_qt4 poppler_qt5; } // poppler_glib
