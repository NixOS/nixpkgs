{ lib, stdenv, fetchurl
# Image file formats
, libjpeg, libtiff, giflib, libpng, libwebp, libjxl
, libspectre
# imlib2 can load images from ID3 tags.
, libid3tag, librsvg, libheif
, freetype , bzip2, pkg-config
, x11Support ? true, xlibsWrapper ? null
# Compilation error on Darwin with librsvg. For more information see:
# https://github.com/NixOS/nixpkgs/pull/166452#issuecomment-1090725613
, svgSupport ? !stdenv.isDarwin
, heifSupport ? !stdenv.isDarwin
, webpSupport ? true
, jxlSupport ? true
, psSupport ? true

# for passthru.tests
, libcaca
, diffoscopeMinimal
, feh
, icewm
, openbox
, fluxbox
, enlightenment
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "imlib2";
  version = "1.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/${pname}-${version}.tar.xz";
    hash = "sha256-SiJAOL//vl1NJQxE4F9O5a4k3P74OVsWd8cVxY92TUM=";
  };

  buildInputs = [
    libjpeg libtiff giflib libpng
    bzip2 freetype libid3tag
  ] ++ optional x11Support xlibsWrapper
    ++ optional heifSupport libheif
    ++ optional svgSupport librsvg
    ++ optional webpSupport libwebp
    ++ optional jxlSupport libjxl
    ++ optional psSupport libspectre;

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  # Do not build amd64 assembly code on Darwin, because it fails to compile
  # with unknow directive errors
  configureFlags = optional stdenv.isDarwin "--enable-amd64=no"
    ++ optional (!svgSupport) "--without-svg"
    ++ optional (!heifSupport) "--without-heif"
    ++ optional (!x11Support) "--without-x";

  outputs = [ "bin" "out" "dev" ];

  passthru.tests = {
    inherit
      libcaca
      diffoscopeMinimal
      feh
      icewm
      openbox
      fluxbox
      enlightenment;
  };

  meta = with lib; {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    homepage = "https://docs.enlightenment.org/api/imlib2/html";
    changelog = "https://git.enlightenment.org/legacy/imlib2.git/plain/ChangeLog?h=v${version}";
    license = licenses.imlib2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ spwhitt ];
  };
}
