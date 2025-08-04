{
  cudaAtLeast,
  cudaMajorMinorVersion,
  cudaOlder,
  e2fsprogs,
  elfutils,
  gst_all_1,
  lib,
  qt5 ? null,
  qt6 ? null,
  rdma-core,
  stdenv,
  ucx,
}:
prevAttrs:
let
  inherit (lib.strings) versionOlder versionAtLeast;
  inherit (prevAttrs) version;
  qt = if versionOlder version "2022.2.0" then qt5 else qt6;
  qtwayland =
    if lib.versions.major qt.qtbase.version == "5" then
      lib.getBin qt.qtwayland
    else
      lib.getLib qt.qtwayland;
  inherit (qt) wrapQtAppsHook qtwebview;
  archDir =
    {
      aarch64-linux = "linux-desktop-t210-a64";
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
    ++ lib.optionals (cudaAtLeast "12.1" && cudaOlder "12.4") [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
    ]
    ++ lib.optionals (cudaAtLeast "12.0" && cudaOlder "12.7") [
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
  postInstall = prevAttrs.postInstall or "" + ''
    moveToOutput 'ncu' "''${!outputBin}/bin"
    moveToOutput 'ncu-ui' "''${!outputBin}/bin"
    moveToOutput 'host/${archDir}' "''${!outputBin}/bin"
    moveToOutput 'target/${archDir}' "''${!outputBin}/bin"
    wrapQtApp "''${!outputBin}/bin/host/${archDir}/ncu-ui.bin"
  '';
  # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
  preFixup = prevAttrs.preFixup or "" + ''
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/bin/host/${archDir}/Plugins/imageformats/libqtiff.so"
  '';
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
  brokenConditions = prevAttrs.brokenConditions or { } // {
    "Qt 5 missing (<2022.2.0)" = !(versionOlder version "2022.2.0" -> qt5 != null);
    "Qt 6 missing (>=2022.2.0)" = !(versionAtLeast version "2022.2.0" -> qt6 != null);
  };
}
