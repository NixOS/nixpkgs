{
  boost178,
  cuda_cudart,
  cudaAtLeast,
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
  qtwayland = lib.getLib qt6.qtwayland;
  qtWaylandPlugins = "${qtwayland}/${qt6.qtbase.qtPluginPrefix}";
  # NOTE(@connorbaker): nsight_systems doesn't support Jetson, so no need for case splitting on aarch64-linux.
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
in
{
  outputs = [ "out" ]; # NOTE(@connorbaker): Force a single output so relative lookups work.

  # An ad hoc replacement for
  # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
  env = prevAttrs.env or { } // {
    rmPatterns =
      prevAttrs.env.rmPatterns or ""
      + toString [
        "${hostDir}/lib{arrow,jpeg}*"
        "${hostDir}/lib{ssl,ssh,crypto}*"
        "${hostDir}/libboost*"
        "${hostDir}/libexec"
        "${hostDir}/libstdc*"
        "${hostDir}/python/bin/python"
        "${hostDir}/Mesa"
      ];
  };

  # NOTE(@connorbaker): nsight-exporter and nsight-sys are deprecated scripts wrapping nsys, it's fine to remove them.
  prePatch = prevAttrs.prePatch or "" + ''
    if [[ -d bin ]]; then
      nixLog "Removing bin wrapper scripts"
      for knownWrapper in bin/{nsys{,-ui},nsight-{exporter,sys}}; do
        [[ -e $knownWrapper ]] && rm -v "$knownWrapper"
      done
      unset -v knownWrapper

      nixLog "Removing empty bin directory"
      rmdir -v bin
    fi

    if [[ -d nsight-systems ]]; then
      nixLog "Lifting components of Nsight System to the top level"
      mv -v nsight-systems/*/* .
      nixLog "Removing empty nsight-systems directory"
      rmdir -pv nsight-systems/*
    fi
  '';

  postPatch = prevAttrs.postPatch or "" + ''
    for path in $rmPatterns; do
      rm -r "$path"
    done
    patchShebangs nsight-systems
  '';

  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ qt6.wrapQtAppsHook ];

  dontWrapQtApps = true;

  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [
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
    ]
    # NOTE(@connorbaker): Seems to be required only for aarch64-linux.
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      gst_all_1.gst-plugins-bad
    ];

  postInstall = prevAttrs.postInstall or "" + ''
    moveToOutput '${hostDir}' "''${!outputBin}"
    moveToOutput '${targetDir}' "''${!outputBin}"
    moveToOutput 'bin' "''${!outputBin}"
    wrapQtApp "''${!outputBin}/${hostDir}/nsys-ui.bin"
  '';

  # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
  preFixup = prevAttrs.preFixup or "" + ''
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/${hostDir}/Plugins/imageformats/libqtiff.so"
  '';

  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
}
