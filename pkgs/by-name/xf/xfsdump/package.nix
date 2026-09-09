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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfsdump";
  version = "3.3.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/xfsdump/xfsdump-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-nKPpEFWUX4pwvU1GXVRk9jFjDGVGKJbtpHnXNx/WHbc=";
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
  # xfsdump doesn't use flexible array. The old dh_name[6] causes buffer
  # overflow crash while strcpy() in various places.
  # See:
  # https://github.com/NixOS/nixpkgs/pull/533325
  # https://lore.kernel.org/linux-xfs/20260625222337.54449-1-celeste@collar.sh/T/#u
  patches = [
    (fetchpatch {
      url = "https://lore.kernel.org/linux-xfs/20260625222337.54449-1-celeste@collar.sh/raw";
      sha256 = "sha256-iOxnd9lgdeNQThinzEjMRKN90YLRcGdTuczUFU61Cm8=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "cp include/install-sh ." "cp -f include/install-sh ."
  '';

  # Configure scripts don't check PATH, see xfstests derivation
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
