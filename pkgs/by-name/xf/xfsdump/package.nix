{
  lib,
  stdenv,
  fetchurl,
  attr,
  gettext,
  autoconf,
  automake,
  ncurses,
  libtool,
  libuuid,
  libxfs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfsdump";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/xfsdump/xfsdump-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-KRTbvh68iMfZOtiOIgqlfavEPSFuEfBiIcAe3zzBBzI=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];
  buildInputs = [
    attr
    libuuid
    libxfs
    ncurses
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "cp include/install-sh ." "cp -f include/install-sh ."
  '';

  # Conifigure scripts don't check PATH, see xfstests derviation
  preConfigure = ''
    export MAKE=$(type -P make)
    export MSGFMT=$(type -P msgfmt)
    export MSGMERGE=$(type -P msgmerge)
    export XGETTEXT=$(type -P xgettext)

    make configure
    patchShebangs ./install-sh
  '';

  meta = {
    description = "XFS filesystem incremental dump utility";
    homepage = "https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/tree/doc/CHANGES";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.lunik1 ];
    platforms = lib.platforms.linux;
  };
})
