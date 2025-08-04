{
  boost178,
  cuda_cudart,
  e2fsprogs,
  gst_all_1,
  lib,
  nss,
  numactl,
  pulseaudio,
  qt6,
  rdma-core,
  stdenv,
  ucx,
  wayland,
  xorg,
}:
prevAttrs:
let
  inherit (prevAttrs) version;
  qtwayland = lib.getLib qt6.qtwayland;
  qtWaylandPlugins = "${qtwayland}/${qt6.qtbase.qtPluginPrefix}";
  hostDir =
    {
      aarch64-linux = "host-linux-armv8";
      x86_64-linux = "host-linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  targetDir =
    {
      aarch64-linux = "target-linux-sbsa-armv8";
      x86_64-linux = "target-linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  versionString = with lib.versions; "${majorMinor version}.${patch version}";
in
{
  # An ad hoc replacement for
  # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
  env = prevAttrs.env or { } // {
    rmPatterns =
      prevAttrs.env.rmPatterns or ""
      + toString [
        "nsight-systems/${versionString}/${hostDir}/lib{arrow,jpeg}*"
        "nsight-systems/${versionString}/${hostDir}/lib{ssl,ssh,crypto}*"
        "nsight-systems/${versionString}/${hostDir}/libboost*"
        "nsight-systems/${versionString}/${hostDir}/libexec"
        "nsight-systems/${versionString}/${hostDir}/libstdc*"
        "nsight-systems/${versionString}/${hostDir}/python/bin/python"
        "nsight-systems/${versionString}/${hostDir}/Mesa"
      ];
  };
  postPatch = prevAttrs.postPatch or "" + ''
    for path in $rmPatterns; do
      rm -r "$path"
    done
    patchShebangs nsight-systems
  '';
  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ qt6.wrapQtAppsHook ];
  dontWrapQtApps = true;
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    (qt6.qtdeclarative or qt6.full)
    (qt6.qtsvg or qt6.full)
    (qt6.qtimageformats or qt6.full)
    (qt6.qtpositioning or qt6.full)
    (qt6.qtscxml or qt6.full)
    (qt6.qttools or qt6.full)
    (qt6.qtwebengine or qt6.full)
    (qt6.qtwayland or qt6.full)
    boost178
    cuda_cudart.stubs
    e2fsprogs
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    nss
    numactl
    pulseaudio
    qt6.qtbase
    qtWaylandPlugins
    rdma-core
    ucx
    wayland
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
  ];

  postInstall =
    prevAttrs.postInstall or ""
    # 1. Move dependencies of nsys, nsys-ui binaries to bin output
    # 2. Fix paths in wrapper scripts
    + ''
      moveToOutput 'nsight-systems/${versionString}/${hostDir}' "''${!outputBin}"
      moveToOutput 'nsight-systems/${versionString}/${targetDir}' "''${!outputBin}"
      moveToOutput 'nsight-systems/${versionString}/bin' "''${!outputBin}"
      substituteInPlace $bin/bin/nsys $bin/bin/nsys-ui \
        --replace-fail 'nsight-systems-#VERSION_RSPLIT#' nsight-systems/${versionString}
      wrapQtApp "$bin/nsight-systems/${versionString}/${hostDir}/nsys-ui.bin"
    '';

  preFixup = prevAttrs.preFixup or "" + ''
    # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so $bin/nsight-systems/${versionString}/${hostDir}/Plugins/imageformats/libqtiff.so
  '';

  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
}
