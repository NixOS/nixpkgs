{ stdenv, fetchurl, fetchgit, pkgconfig, cmake, libiconvOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms2, libjpeg, openjpeg
, qt4Support ? false, qt4 ? null
}:

let
  version = "0.22.4"; # even major numbers are stable
  sha256 = "0fz1vk0rbxvnv7ssj8l910k1rx0gjhzl5wr7hkdf4r9jwqs8yhsg";

  qtcairo_patches =
    let qtcairo = fetchgit { # the version for poppler-0.22
      url = "git://github.com/giddie/poppler-qt4-cairo-backend.git";
      rev = "7a12c58e5cefc2b7a5179c53b387fca8963195c0";
      sha256 = "1jg2d5y62d0bv206nijb63x426zfb2awy70505nx22d0fx1v1p9k";
    }; in
      [ "${qtcairo}/0001-Cairo-backend-added-to-Qt4-wrapper.patch"
        "${qtcairo}/0002-Setting-default-Qt4-backend-to-Cairo.patch"
        "${qtcairo}/0003-Forcing-subpixel-rendering-in-Cairo-backend.patch" ];

  poppler_drv = nameSuff: merge: stdenv.mkDerivation (stdenv.lib.mergeAttrsByFuncDefaultsClean [
  rec {
    name = "poppler-${nameSuff}-${version}";

    src = fetchurl {
      url = "${meta.homepage}/poppler-${version}.tar.gz";
      inherit sha256;
    };

    propagatedBuildInputs = [ zlib cairo freetype fontconfig libjpeg lcms2 curl openjpeg ];

    nativeBuildInputs = [ pkgconfig cmake ] ++ libiconvOrEmpty;

    cmakeFlags = "-DENABLE_XPDF_HEADERS=ON -DENABLE_LIBCURL=ON -DENABLE_ZLIB=ON";

    patches = [ ./datadir_env.patch ];

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

      license = "GPLv2";
    };
  } merge ]); # poppler_drv

in rec {
  /* We always use cairo in poppler, so we always depend on glib,
     so we always build the glib wrapper (~350kB).
     We also always build the cpp wrapper (<100kB).
     ToDo: around half the size could be saved by splitting out headers and tools (1.5 + 0.5 MB).
  */

  poppler_glib = poppler_drv "glib" { };

  poppler_qt4 = poppler_drv "qt4" {
    propagatedBuildInputs = [ qt4 poppler_glib ];
    patches = qtcairo_patches;
    NIX_LDFLAGS = "-lpoppler";
    postConfigure = "cd qt4";
  };
}
