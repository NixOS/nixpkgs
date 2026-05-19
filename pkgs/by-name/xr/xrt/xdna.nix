{
  lib,
  stdenv,
  fetchFromGitHub,
  symlinkJoin,
  cmake,
  pkg-config,
  git,
  python3,
  gawk,
  xrt,
  boost,
  libdrm,
  libuuid,
  libelf,
  ocl-icd,
  opencl-headers,
  ncurses,
  libxml2,
  yaml-cpp,
  openssl,
  rapidjson,
  protobuf,
  systemd,
  libsystemtap,
}:

let
  # Build the NPU-aware plugin
  xrt-amdxdna-plugin = stdenv.mkDerivation {
    pname = "xrt-amdxdna-plugin";
    version = xrt.version;

    src = fetchFromGitHub {
      owner = "amd";
      repo = "xdna-driver";
      tagv = xrt.version;
      fetchSubmodules = true;
      hash = "sha256-bBiI42bwap6O59MQdIylX7uz+fLUF75RTyNWTJfAFds=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      git
      python3
      gawk
    ];

    buildInputs = [
      xrt
      boost
      libdrm
      libuuid
      libelf
      ocl-icd
      opencl-headers
      ncurses
      libxml2
      yaml-cpp
      openssl
      rapidjson
      protobuf
      systemd
      libsystemtap
    ];

    env.LDFLAGS = "-Wl,--copy-dt-needed-entries";

    # Create fake os-release for build scripts
    preConfigure = ''
      mkdir -p $TMPDIR/etc
      echo 'ID=nixos' > $TMPDIR/etc/os-release
      export NIX_REDIRECTS=/etc/os-release=$TMPDIR/etc/os-release
    '';

    cmakeFlags = [
      (lib.cmakeBool "SKIP_KMOD" true)
    ];

    # Fix hardcoded /bins path
    preInstall = ''
      find . -name cmake_install.cmake -exec sed -i \
        -e 's|/bins/|'"$out"'/bins/|g' \
        {} \;
    '';

    # Flatten nested paths from bins/
    postInstall = ''
      if [ -d "$out/bins$out" ]; then
        cp -rn "$out/bins$out"/* "$out/" || true
        rm -rf "$out/bins"
      fi
      # Flatten nested paths from $out$out
      if [ -d "$out$out" ]; then
        cp -rn "$out$out"/* "$out/" || true
        rm -rf "$out/nix"
      fi
      # Also check for opt/xilinx
      if [ -d "$out/opt/xilinx/xrt/lib" ]; then
        cp -r $out/opt/xilinx/xrt/lib/* $out/lib/ || true
      fi
    '';

    meta = {
      description = "AMD XDNA driver userspace plugin for XRT";
      homepage = "https://github.com/amd/xdna-driver";
      license = lib.licenses.asl20;
      maintainers = [ ];
      platforms = lib.platforms.linux;
    };
  };
in
# Merge xrt (headers) with xrt-amdxdna-plugin (NPU-aware libs)
# Plugin comes first so its libs override base xrt
symlinkJoin {
  name = "xrt-amdxdna-${xrt.version}";
  paths = [
    xrt-amdxdna-plugin
    xrt
  ];

  passthru = {
    plugin = xrt-amdxdna-plugin;
  };

  meta = {
    description = "Xilinx Runtime with AMD XDNA NPU support for Ryzen AI";
    homepage = "https://github.com/amd/xdna-driver";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
