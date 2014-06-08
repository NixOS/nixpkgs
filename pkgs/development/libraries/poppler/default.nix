{ stdenv, fetchurl, fetchgit, pkgconfig, cmake, libiconvOrEmpty, libintlOrEmpty
, zlib, curl, cairo, freetype, fontconfig, lcms, libjpeg, openjpeg
, qt4Support ? false, qt4 ? null
}:

let
  version = "0.24.5"; # even major numbers are stable
  sha256 = "114zfm4771iq25wa4bsg4nc2gnr6waaj8936wd23r4hc2084jrd2";

  qtcairo_patches =
    let qtcairo = fetchgit { # the version for poppler-0.24
      url = "git://github.com/giddie/poppler-qt4-cairo-backend.git";
      rev = "c4578cde09834e0d70873f63b1c2a410f66bb4f9";
      sha256 = "07bs2phmp7f4mqrwqz2bgyw2gw7s00mwsm548bsikyz1cbj7fl93";
    }; in
      [ "${qtcairo}/0001-Cairo-backend-added-to-Qt4-wrapper.patch"
        "${qtcairo}/0002-Setting-default-Qt4-backend-to-Cairo.patch"
        "${qtcairo}/0003-Forcing-subpixel-rendering-in-Cairo-backend.patch" ];

  poppler_drv = nameSuff: merge: stdenv.mkDerivation (stdenv.lib.mergeAttrsByFuncDefaultsClean [
  rec {
    name = "poppler-${nameSuff}-${version}";

    src = fetchurl {
      url = "${meta.homepage}/poppler-${version}.tar.xz";
      inherit sha256;
    };

    propagatedBuildInputs = [ zlib cairo freetype fontconfig libjpeg lcms curl openjpeg ];

    nativeBuildInputs = [ pkgconfig cmake ] ++ libiconvOrEmpty ++ libintlOrEmpty;

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

      license = "GPLv2";
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
    propagatedBuildInputs = [ qt4 poppler_glib ];
    patches = qtcairo_patches;
    NIX_LDFLAGS = "-lpoppler";
    postConfigure = ''
      mkdir -p "$out/lib/pkgconfig"
      install -c -m 644 poppler-qt4.pc "$out/lib/pkgconfig"
      cd qt4
    '';
  };

in { inherit poppler_glib poppler_qt4; } // poppler_glib
