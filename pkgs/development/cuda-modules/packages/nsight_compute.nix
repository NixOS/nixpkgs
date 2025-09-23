{
  backendStdenv,
  buildRedist,
  cudaAtLeast,
  cudaOlder,
  e2fsprogs,
  elfutils,
  flags,
  lib,
  qt6,
  rdma-core,
  ucx,
}:
let
  qtwayland = lib.getLib qt6.qtwayland;
  inherit (qt6) wrapQtAppsHook qtwebview;
  archDir =
    {
      aarch64-linux = "linux-" + (if flags.isJetsonBuild then "v4l_l4t" else "desktop") + "-t210-a64";
      x86_64-linux = "linux-desktop-glibc_2_11_3-x64";
    }
    .${backendStdenv.hostPlatform.system}
      or (throw "Unsupported system: ${backendStdenv.hostPlatform.system}");
in
buildRedist {
  redistName = "cuda";
  pname = "nsight_compute";

  # NOTE(@connorbaker): It might be a problem that when nsight_compute contains hosts and targets of different
  # architectures, that we patchelf just the binaries matching the builder's platform; autoPatchelfHook prints
  # messages like
  #   skipping [$out]/host/linux-desktop-glibc_2_11_3-x64/libQt6Core.so.6 because its architecture (x64) differs from
  #   target (AArch64)
  outputs = [ "out" ];

  allowFHSReferences = true;

  nativeBuildInputs = [ wrapQtAppsHook ];

  buildInputs = [
    qtwayland
    qtwebview
    (qt6.qtwebengine or qt6.full)
    rdma-core
  ]
  ++ lib.optionals (cudaOlder "12.7") [
    e2fsprogs
    ucx
  ]
  ++ lib.optionals (cudaAtLeast "12.9") [ elfutils ];

  dontWrapQtApps = true;

  preInstall = ''
    if [[ -d nsight-compute ]]; then
      nixLog "Lifting components of Nsight Compute to the top level"
      mv -v nsight-compute/*/* .
      nixLog "Removing empty directories"
      rmdir -pv nsight-compute/*
    fi

    rm -rf host/${archDir}/Mesa/
  '';

  postInstall = ''
    moveToOutput 'ncu' "''${!outputBin}/bin"
    moveToOutput 'ncu-ui' "''${!outputBin}/bin"
    moveToOutput 'host/${archDir}' "''${!outputBin}/bin"
    moveToOutput 'target/${archDir}' "''${!outputBin}/bin"
    wrapQtApp "''${!outputBin}/bin/host/${archDir}/ncu-ui.bin"
  ''
  # NOTE(@connorbaker): No idea what this platform is or how to patchelf for it.
  + lib.optionalString (flags.isJetsonBuild && cudaOlder "12.9") ''
    nixLog "Removing QNX 700 target directory for Jetson builds"
    rm -rfv "''${!outputBin}/target/qnx-700-t210-a64"
  ''
  + lib.optionalString (flags.isJetsonBuild && cudaAtLeast "12.8") ''
    nixLog "Removing QNX 800 target directory for Jetson builds"
    rm -rfv "''${!outputBin}/target/qnx-800-tegra-a64"
  '';

  # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
  preFixup = ''
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/bin/host/${archDir}/Plugins/imageformats/libqtiff.so"
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libnvidia-ml.so.1"
    "libcuda.so.1"
  ];

  meta = {
    description = "Interactive profiler for CUDA and NVIDIA OptiX";
    longDescription = ''
      NVIDIA Nsight Compute is an interactive profiler for CUDA and NVIDIA OptiX that provides detailed performance
      metrics and API debugging via a user interface and command-line tool. Users can run guided analysis and compare
      results with a customizable and data-driven user interface, as well as post-process and analyze results in their
      own workflows.
    '';
    homepage = "https://developer.nvidia.com/nsight-compute";
    changelog = "https://docs.nvidia.com/nsight-compute/ReleaseNotes";

    mainProgram = "ncu";
  };
}
