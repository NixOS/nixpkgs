{
  lib,
  callPackage,
  fetchurl,
  zlib,
  rdma-core,
  libpsm2,
  ucx,
  numactl,
  level-zero,
  libdrm,
  elfutils,
  libxxf86vm,
  libxrandr,
  libxfixes,
  libxext,
  libxdamage,
  libxcomposite,
  libx11,
  libxcb,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  libgbm,
  expat,
  libxkbcommon,
  eudev,
  alsa-lib,
  ncurses5,
  bzip2,
  gdbm,
  libxcrypt-legacy,
  freetype,
  gtk2,
  gdk-pixbuf,
  fontconfig,
  libuuid,
  sqlite,
  libffi,
  # The list of components to install;
  # Either [ "all" ], [ "default" ], or a custom list of components.
  # If you want to install all default components plus an extra one, pass [ "default" <your extra components here> ]
  # Note that changing this will also change the `buildInputs` of the derivation.
  # The default value is not "default" because some of the components in the defualt set are currently broken.
  components ? [
    "intel.oneapi.lin.advisor"
    "intel.oneapi.lin.dpcpp-cpp-compiler"
    "intel.oneapi.lin.dpcpp_dbg"
    "intel.oneapi.lin.vtune"
    "intel.oneapi.lin.mkl.devel"
  ],
  intel-oneapi,
}:
intel-oneapi.mkIntelOneApi (finalAttrs: {
  pname = "intel-oneapi-base-toolkit";

  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/6caa93ca-e10a-4cc5-b210-68f385feea9e/intel-oneapi-base-toolkit-2025.3.1.36_offline.sh";
    hash = "sha256-xXV6FP4t1ChSi/bcDFpkmMexNejPTtk2Nay/PmSpCFA=";
  };

  versionYear = "2025";
  versionMajor = "3";
  versionMinor = "1";
  versionRel = "36";

  inherit components;

  # Figured out by looking at autoPatchelfHook failure output
  depsByComponent = rec {
    advisor = [
      libdrm
      zlib
      gtk2
      gdk-pixbuf
      at-spi2-atk
      glib
      pango
      gdk-pixbuf
      cairo
      fontconfig
      glib
      freetype
      libx11
      libxxf86vm
      libxext
      libxcb
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      nss
      dbus
      cups
      libgbm
      expat
      libxkbcommon
      eudev
      alsa-lib
      ncurses5
      bzip2
      libuuid
      gdbm
      libxcrypt-legacy
      sqlite
      nspr
    ];
    dpcpp-cpp-compiler = [
      zlib
      level-zero
    ];
    dpcpp_dbg = [
      level-zero
      zlib
    ];
    dpcpp-ct = [ zlib ];
    mpi = [
      zlib
      rdma-core
      libpsm2
      ucx
      libuuid
      numactl
      level-zero
      libffi
    ];
    pti = [ level-zero ];
    vtune = [
      libdrm
      elfutils
      zlib
      libx11
      libxext
      libxcb
      libxcomposite
      libxdamage
      libxfixes
      libxrandr
      glib
      nss
      dbus
      at-spi2-atk
      cups
      gtk3
      pango
      cairo
      libgbm
      expat
      libxkbcommon
      eudev
      alsa-lib
      at-spi2-atk
      ncurses5
      bzip2
      libuuid
      gdbm
      libxcrypt-legacy
      sqlite
      nspr
    ];
    mkl = mpi ++ pti;
  };

  autoPatchelfIgnoreMissingDeps = [
    # Needs to be dynamically loaded as it depends on the hardware
    "libcuda.so.1"
    # All too old, not in nixpkgs anymore
    "libffi.so.6"
    "libgdbm.so.4"
    "libopencl-clang.so.14"
    "libreadline.so.6"
  ];

  passthru.updateScript = intel-oneapi.mkUpdateScript {
    inherit (finalAttrs) pname;
    file = "base.nix";
    downloadPage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=offline";
  };

  passthru.stdenv = callPackage ./stdenv.nix { kit = intel-oneapi.base; };

  passthru.tests = callPackage ./tests.nix { kit = intel-oneapi.base; };

  meta = {
    description = "Intel oneAPI Base Toolkit";
    homepage = "https://software.intel.com/content/www/us/en/develop/tools/oneapi/base-toolkit.html";
    license = with lib.licenses; [
      intel-eula
      issl
      asl20
    ];
    maintainers = with lib.maintainers; [
      balsoft
    ];
    platforms = [ "x86_64-linux" ];
  };
})
