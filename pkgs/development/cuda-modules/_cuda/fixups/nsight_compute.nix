{
  lib,
  qt5 ? null,
  qt6 ? null,
  rdma-core,
  stdenv,
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
  nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [ wrapQtAppsHook ];
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    qtwayland
    qtwebview
    (qt.qtwebengine or qt.full)
    rdma-core
  ];
  dontWrapQtApps = true;
  preInstall =
    prevAttrs.preInstall or ""
    + ''
      rm -rf host/${archDir}/Mesa/
    '';
  postInstall =
    prevAttrs.postInstall or ""
    + ''
      mkdir -p "$out/bin"
      moveToOutput 'host/${archDir}' "$out"
      moveToOutput 'target/${archDir}' "$out"
      wrapQtApp "$out/host/${archDir}/ncu-ui.bin"
      ln -snf "$out/target/linux-desktop-glibc_2_11_3-x64/ncu" "$out/bin/"
      ln -snf "$out/host/linux-desktop-glibc_2_11_3-x64/ncu-ui" "$out/bin/"
      rm "$out/ncu" "$out/ncu-ui"
    '';
  preFixup =
    prevAttrs.preFixup or ""
    + ''
      # lib needs libtiff.so.5, but nixpkgs provides libtiff.so.6
      patchelf --replace-needed libtiff.so.5 libtiff.so "$out/host/${archDir}/Plugins/imageformats/libqtiff.so"
    '';
  autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps or [ ] ++ [
    "libnvidia-ml.so.1"
  ];
  brokenConditions = prevAttrs.brokenConditions or { } // {
    "Qt 5 missing (<2022.2.0)" = !(versionOlder version "2022.2.0" -> qt5 != null);
    "Qt 6 missing (>=2022.2.0)" = !(versionAtLeast version "2022.2.0" -> qt6 != null);
  };
}
