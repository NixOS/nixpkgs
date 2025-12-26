{
  backendStdenv,
  boost178,
  buildRedist,
  cudaAtLeast,
  e2fsprogs,
  gst_all_1,
  lib,
  nss,
  numactl,
  pulseaudio,
  qt5 ? null,
  qt6 ? null,
  rdma-core,
  ucx,
  wayland,
  xorg,
}:
let
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
buildRedist (
  finalAttrs:
  let
    qt = if lib.strings.versionOlder finalAttrs.version "2022.4.2.1" then qt5 else qt6;
    qtwayland =
      if lib.versions.major qt.qtbase.version == "5" then
        lib.getBin qt.qtwayland
      else
        lib.getLib qt.qtwayland;
    qtWaylandPlugins = "${qtwayland}/${qt.qtbase.qtPluginPrefix}";
    inherit (qt) wrapQtAppsHook qtwebengine;
  in
  {
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
      patchShebangs .
    '';

    nativeBuildInputs = [ wrapQtAppsHook ];

    dontWrapQtApps = true;

    # TODO(@connorbaker): Fix dependencies for earlier (CUDA <12.6) versions of nsight_systems.
    buildInputs = [
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qtimageformats
      qt6.qtpositioning
      qt6.qtscxml
      qt6.qttools
      qtwebengine
      qt6.qtwayland
      boost178
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
    ++ lib.optionals (backendStdenv.hostPlatform.isAarch64 && cudaAtLeast "11.8") [
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
      "libcuda.so.1"
      "libnvidia-ml.so.1"
    ];

    brokenAssertions = [
      {
        # Boost 1.70 has been deprecated in Nixpkgs; releases older than the one for CUDA 11.8 are not supported.
        message = "Boost 1.70 is required and available";
        assertion = lib.versionAtLeast finalAttrs.version "2022.4.2.1";
      }
      {
        message = "Qt 5 is required and available";
        assertion = lib.versionOlder finalAttrs.version "2022.4.2.1" -> qt5 != null;
      }
      {
        message = "Qt 6 is required and available";
        assertion = lib.versionAtLeast finalAttrs.version "2022.4.2.1" -> qt6 != null;
      }
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
)
