{
  lib,
  qt6,
  rdma-core,
  stdenv,
}:
prevAttrs:
let
  qtwayland = lib.getLib qt6.qtwayland;
  inherit (qt6) wrapQtAppsHook qtwebview;
  archDir =
    {
      aarch64-linux = "linux-desktop-t210-a64";
      x86_64-linux = "linux-desktop-glibc_2_11_3-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
{
  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ wrapQtAppsHook ];
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    qtwayland
    qtwebview
    (qt6.qtwebengine or qt6.full)
    rdma-core
  ];
  dontWrapQtApps = true;
  preInstall = prevAttrs.preInstall or "" + ''
    rm -rf host/${archDir}/Mesa/
  '';
  postInstall = prevAttrs.postInstall or "" + ''
    moveToOutput 'ncu' "''${!outputBin}/bin"
    moveToOutput 'ncu-ui' "''${!outputBin}/bin"
    moveToOutput 'host/${archDir}' "''${!outputBin}/bin"
    moveToOutput 'target/${archDir}' "''${!outputBin}/bin"
    wrapQtApp "''${!outputBin}/bin/host/${archDir}/ncu-ui.bin"
  '';
  preFixup = prevAttrs.preFixup or "" + ''
    # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
    patchelf --replace-needed libtiff.so.5 libtiff.so "''${!outputBin}/bin/host/${archDir}/Plugins/imageformats/libqtiff.so"
  '';
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
}
