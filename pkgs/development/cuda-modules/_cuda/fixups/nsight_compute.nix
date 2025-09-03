{
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaOlder,
  e2fsprogs,
  elfutils,
  flags,
  gst_all_1,
  lib,
  libjpeg8,
  qt6,
  rdma-core,
  stdenv,
  ucx,
}:
prevAttrs:
let
  qtwayland = lib.getLib qt6.qtwayland;
  inherit (qt6) wrapQtAppsHook qtwebview;
  archDir =
    {
      aarch64-linux = "linux-" + (if flags.isJetsonBuild then "v4l_l4t" else "desktop") + "-t210-a64";
      x86_64-linux = "linux-desktop-glibc_2_11_3-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
{
  outputs = [ "out" ]; # NOTE(@connorbaker): Force a single output so relative lookups work.
  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ wrapQtAppsHook ];
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [
      qtwayland
      qtwebview
      (qt6.qtwebengine or qt6.full)
      rdma-core
    ]
    ++ lib.optionals (cudaOlder "12.7") [
      e2fsprogs
      ucx
    ]
    ++ lib.optionals (cudaMajorMinorVersion == "12.9") [
      elfutils
    ];
  dontWrapQtApps = true;
  preInstall = prevAttrs.preInstall or "" + ''
    if [[ -d nsight-compute ]]; then
      nixLog "Lifting components of Nsight Compute to the top level"
      mv -v nsight-compute/*/* .
      nixLog "Removing empty directories"
      rmdir -pv nsight-compute/*
    fi

    rm -rf host/${archDir}/Mesa/
  '';
  postInstall =
    prevAttrs.postInstall or ""
    + ''
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
  preFixup = prevAttrs.preFixup or "" + ''
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/bin/host/${archDir}/Plugins/imageformats/libqtiff.so"
  '';
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
  # NOTE(@connorbaker): It might be a problem that when nsight_compute contains hosts and targets of different
  # architectures, that we patchelf just the binaries matching the builder's platform; autoPatchelfHook prints
  # messages like
  #   skipping [$out]/host/linux-desktop-glibc_2_11_3-x64/libQt6Core.so.6 because its architecture (x64) differs from
  #   target (AArch64)
}
