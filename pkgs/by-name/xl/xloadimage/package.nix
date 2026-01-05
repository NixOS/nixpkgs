{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  libX11,
  libXt,
  autoreconfHook,
  quilt,

  libjpeg ? null,
  libpng ? null,
  libtiff ? null,

  withJpegSupport ? true,
  withPngSupport ? true,
  withTiffSupport ? true,
}:

assert withJpegSupport -> libjpeg != null;
assert withPngSupport -> libpng != null;
assert withTiffSupport -> libtiff != null;

let
  version = "4.1";
  deb_patch = "25";
  debian_patches = fetchzip {
    url = "mirror://debian/pool/main/x/xloadimage/xloadimage_${version}-${deb_patch}.debian.tar.xz";
    hash = "sha256-5FbkiYjI8ASUyi1DTFiAcJ9y2z1sEKrNNyKoqnca30I=";
  };
in
stdenv.mkDerivation rec {
  pname = "xloadimage";
  inherit version;

  src = fetchurl {
    url = "mirror://debian/pool/main/x/xloadimage/xloadimage_${version}.orig.tar.gz";
    sha256 = "1i7miyvk5ydhi6yi8593vapavhwxcwciir8wg9d2dcyg9pccf2s0";
  };

  postPatch = ''
    QUILT_PATCHES=${debian_patches}/patches quilt push -a
  '';

  nativeBuildInputs = [
    autoreconfHook
    quilt
  ];

  buildInputs = [
    libX11
    libXt
  ]
  ++ lib.optionals withJpegSupport [
    libjpeg
  ]
  ++ lib.optionals withPngSupport [
    libpng
  ]
  ++ lib.optionals withTiffSupport [
    libtiff
  ];

  # NOTE: we patch the build-info script so that it never detects the utilities
  # it's trying to find; one of the Debian patches adds support for
  # $SOURCE_DATE_EPOCH, but we want to make sure we don't even call these.
  preConfigure = ''
    substituteInPlace build-info \
      --replace-fail '[ -x /bin/date ]' 'false' \
      --replace-fail '[ -x /bin/id ]' 'false' \
      --replace-fail '[ -x /bin/uname ]' 'false' \
      --replace-fail '[ -x /usr/bin/id ]' 'false'

    chmod +x build-info configure
  '';

  enableParallelBuilding = true;

  # creating patch would add more complexity
  env.CFLAGS = "-Wno-implicit-int";

  # NOTE: we're not installing the `uufilter` binary; if needed, the standard
  # `uudecode` tool should work just fine.
  installPhase = ''
    install -Dm755 xloadimage $out/bin/xloadimage
    ln -sv $out/bin/{xloadimage,xsetbg}

    install -D -m644 xloadimagerc $out/etc/xloadimagerc.example
    install -D -m644 xloadimage.man $out/share/man/man1/xloadimage.1x
    ln -sv $out/share/man/man1/{xloadimage,xsetbg}.1x
  '';

  meta = {
    description = "Graphics file viewer under X11";

    longDescription = ''
      Can view png, jpeg, gif, tiff, niff, sunraster, fbm, cmuraster, pbm,
      faces, rle, xwd, vff, mcidas, vicar, pcx, gem, macpaint, xpm and xbm
      files. Can view images, put them on the root window, or dump them. Does a
      variety of processing, including: clipping, dithering, depth reduction,
      zoom, brightening/darkening and merging.
    '';

    license = lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.linux; # arbitrary choice
  };
}
