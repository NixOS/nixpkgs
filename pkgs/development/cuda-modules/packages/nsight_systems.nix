{
  backendStdenv,
  boost178,
  buildRedist,
  cuda_cudart,
  e2fsprogs,
  gst_all_1,
  lib,
  nss,
  numactl,
  pulseaudio,
  qt6,
  rdma-core,
  ucx,
  wayland,
  xorg,
}:
let
  qtwayland = lib.getLib qt6.qtwayland;
  qtWaylandPlugins = "${qtwayland}/${qt6.qtbase.qtPluginPrefix}";
  # NOTE(@connorbaker): nsight_systems doesn't support Jetson, so no need for case splitting on aarch64-linux.
  hostDir =
    {
      aarch64-linux = "host-linux-armv8";
      x86_64-linux = "host-linux-x64";
    }
    .${backendStdenv.hostPlatform.system}
      or (throw "Unsupported system: ${backendStdenv.hostPlatform.system}");
  targetDir =
    {
      aarch64-linux = "target-linux-sbsa-armv8";
      x86_64-linux = "target-linux-x64";
    }
    .${backendStdenv.hostPlatform.system}
      or (throw "Unsupported system: ${backendStdenv.hostPlatform.system}");
in
buildRedist {
  redistName = "cuda";
  pname = "nsight_systems";

  allowFHSReferences = true;

  outputs = [ "out" ];

  # An ad hoc replacement for
  # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
  env.rmPatterns = toString [
    "${hostDir}/lib{arrow,jpeg}*"
    "${hostDir}/lib{ssl,ssh,crypto}*"
    "${hostDir}/libboost*"
    "${hostDir}/libexec"
    "${hostDir}/libstdc*"
    "${hostDir}/python/bin/python"
    "${hostDir}/Mesa"
  ];

  # NOTE(@connorbaker): nsight-exporter and nsight-sys are deprecated scripts wrapping nsys, it's fine to remove them.
  prePatch = ''
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

  postPatch = ''
    for path in $rmPatterns; do
      rm -r "$path"
    done
    patchShebangs nsight-systems
  '';

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  dontWrapQtApps = true;

  buildInputs = [
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
  ++ lib.optionals backendStdenv.hostPlatform.isAarch64 [
    gst_all_1.gst-plugins-bad
  ];

  postInstall = ''
    moveToOutput '${hostDir}' "''${!outputBin}"
    moveToOutput '${targetDir}' "''${!outputBin}"
    moveToOutput 'bin' "''${!outputBin}"
    wrapQtApp "''${!outputBin}/${hostDir}/nsys-ui.bin"
  '';

  # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
  preFixup = ''
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/${hostDir}/Plugins/imageformats/libqtiff.so"
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libnvidia-ml.so.1"
  ];

  meta = {
    description = "System-wide performance analysis and visualization tool";
    longDescription = ''
      NVIDIA Nsight Systems is a system-wide performance analysis tool designed to visualize an application's
      algorithms, identify the largest opportunities to optimize, and tune to scale efficiently across any quantity or
      size of CPUs and GPUs, from large servers to our smallest systems-on-a-chip (SoCs).
    '';
    homepage = "https://developer.nvidia.com/nsight-systems";
    changelog = "https://docs.nvidia.com/nsight-systems/ReleaseNotes";
  };
}
