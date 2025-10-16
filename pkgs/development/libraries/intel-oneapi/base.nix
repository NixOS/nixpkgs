{
  lib,
  fetchurl,
  zlib,
  rdma-core,
  libpsm2,
  ucx,
  numactl,
  level-zero,
  pkg-config,
  libdrm,
  elfutils,
  xorg,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-atk,
  cups,
  gtk3,
  pango,
  cairo,
  mesa,
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

  # For tests
  runCommand,
  libffi,
  stdenv,
}:
intel-oneapi.mkIntelOneApi (fa: {
  pname = "intel-oneapi-base-toolkit";

  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/3b7a16b3-a7b0-460f-be16-de0d64fa6b1e/intel-oneapi-base-toolkit-2025.2.1.44_offline.sh";
    hash = "sha256-oVURJZG6uZ3YvYefUuqeakbaVR47ZgWduBV6bS6r5Dk=";
  };

  versionYear = "2025";
  versionMajor = "2";
  versionMinor = "1";
  versionRel = "44";

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
      xorg.libX11
      xorg.libXxf86vm
      xorg.libXext
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXrandr
      nss
      dbus
      cups
      mesa
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
      xorg.libX11
      xorg.libXext
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libXrandr
      glib
      nss
      dbus
      at-spi2-atk
      cups
      gtk3
      pango
      cairo
      mesa
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
  ];

  passthru.updateScript = intel-oneapi.mkUpdateScript {
    inherit (fa) pname;
    file = "base.nix";
    downloadPage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=offline";
  };

  passthru.tests = {
    mkl-libs = stdenv.mkDerivation {
      name = "intel-oneapi-test-mkl-libs";
      unpackPhase = ''
        cp ${./test.c} test.c
      '';

      nativeBuildInputs = [
        pkg-config
      ];
      buildInputs = [ intel-oneapi.base ];

      buildPhase = ''
        # This will fail if no libs with mkl- in their name are found
        libs="$(pkg-config --list-all | cut -d\  -f1 | grep mkl-)"
        for lib in $libs; do
          echo "Testing that the build succeeds with $lib" >&2
          gcc test.c -o test-with-$lib $(pkg-config --cflags --libs $lib)
        done
      '';

      doCheck = true;

      checkPhase = ''
        for lib in $libs; do
          echo "Testing that the executable built with $lib runs" >&2
          ./test-with-$lib
        done
      '';

      installPhase = ''
        touch "$out"
      '';
    };

    all-binaries-run = runCommand "intel-oneapi-test-all-binaries-run" { } ''
      # .*-32: 32-bit executables can't be properly patched by patchelf
      # IMB-.*: all fail with a weird "bad file descriptor" error
      # fi_info, fi_pingpong: exits with 1 even if ran with `--help`
      # gdb-openapi: Python not initialized
      # hydra_bstrap_proxy, hydra_nameserver, hydra_pmi_proxy: doesn't respect --help
      # mpirun: can't find mpiexec.hydra for some reason
      # sycl-ls, sycl-trace: doesn't respect --help
      regex_skip="(.*-32)|(IMB-.*)|fi_info|fi_pingpong|gdb-oneapi|hydra_bstrap_proxy|hydra_nameserver|hydra_pmi_proxy|mpirun|sycl-ls|sycl-trace"
      export I_MPI_ROOT="${intel-oneapi.base}/mpi/latest"
      for bin in "${intel-oneapi}"/bin/*; do
        if [[ "$bin" =~ $regex_skip ]] || [ ! -f "$bin" ] || [[ ! -x "$bin" ]]; then
          echo "skipping $bin"
          continue
        fi
        echo "trying to run $bin --help or -help"
        "$bin" --help || "$bin" -help
      done
      touch "$out"
    '';
  };

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
