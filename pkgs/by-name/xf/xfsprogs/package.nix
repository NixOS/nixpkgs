{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  autoreconfHook,
  gettext,
  pkg-config,
  icu,
  libuuid,
  readline,
  inih,
  liburcu,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "xfsprogs";
  version = "6.13.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/xfsprogs/${pname}-${version}.tar.xz";
    hash = "sha256-BFmTP5PZTIK8J4nnvWN0InPZ10IHza5n3DAyA42ggzc=";
  };

  patches = [
    (fetchurl {
      name = "icu76.patch";
      url = "https://lore.kernel.org/linux-xfs/20250212081649.3502717-1-hi@alyssa.is/raw";
      hash = "sha256-Z7BW0B+/5eHWXdHre++wRtdbU/P6XZqudYx6EK5msIU=";
    })
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkg-config
    libuuid # codegen tool uses libuuid
    liburcu # required by crc32selftest
  ];
  buildInputs = [
    readline
    icu
    inih
    liburcu
  ];
  propagatedBuildInputs = [ libuuid ]; # Dev headers include <uuid/uuid.h>

  enableParallelBuilding = true;
  # Install fails as:
  #   make[1]: *** No rule to make target '\', needed by 'kmem.lo'.  Stop.
  enableParallelInstalling = false;

  # @sbindir@ is replaced with /run/current-system/sw/bin to fix dependency cycles
  # and '@pkg_state_dir@' should not point to the nix store, but we cannot use the configure parameter
  # because then it will try to install to /var
  preConfigure = ''
    for file in scrub/*.in; do
      substituteInPlace "$file" \
        --replace-quiet '@sbindir@' '/run/current-system/sw/bin' \
        --replace-quiet '@pkg_state_dir@' '/var'
    done
    patchShebangs ./install-sh
  '';

  # The default --force would replace xfsprogs' custom install-sh.
  autoreconfFlags = [
    "--install"
    "--verbose"
  ];

  configureFlags = [
    "--disable-lib64"
    "--with-systemd-unit-dir=${placeholder "out"}/lib/systemd/system"
  ];

  installFlags = [ "install-dev" ];

  # FIXME: forbidden rpath
  postInstall = ''
    find . -type d -name .libs | xargs rm -rf
  '';

  passthru.tests = {
    inherit (nixosTests.installer) lvm;
  };

  meta = with lib; {
    homepage = "https://xfs.wiki.kernel.org";
    description = "SGI XFS utilities";
    license = with licenses; [
      gpl2Only
      lgpl21
      gpl3Plus
    ]; # see https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/debian/copyright
    platforms = platforms.linux;
    maintainers = with maintainers; [
      dezgeg
      ajs124
    ];
  };
}
