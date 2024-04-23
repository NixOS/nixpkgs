{
  cuda_cudart,
  cudaOlder,
  gst_all_1,
  lib,
  nss,
  numactl,
  pulseaudio,
  qt5 ? null,
  qt6 ? null,
  rdma-core,
  ucx,
  utils,
  wayland,
  xorg,
}:
let
  inherit (lib.attrsets) getOutput optionalAttrs;
  inherit (lib.strings) versionOlder versionAtLeast;
in
prevAttrs:
let
  inherit (prevAttrs) version;
  qt = if lib.strings.versionOlder prevAttrs.version "2022.4.2.1" then qt5 else qt6;
  qtwayland =
    if lib.versions.major qt.qtbase.version == "5" then
      lib.getBin qt.qtwayland
    else
      lib.getLib qt.qtwayland;
  qtWaylandPlugins = "${qtwayland}/${qt.qtbase.qtPluginPrefix}";
in
{
  # An ad hoc replacement for
  # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
  env = prevAttrs.env or { } // {
    rmPatterns = toString [
      "nsight-systems/*/*/lib{arrow,jpeg}*"
      "nsight-systems/*/*/lib{ssl,ssh,crypto}*"
      "nsight-systems/*/*/libboost*"
      "nsight-systems/*/*/libexec"
      "nsight-systems/*/*/libQt*"
      "nsight-systems/*/*/libstdc*"
      "nsight-systems/*/*/Mesa"
      "nsight-systems/*/*/Plugins"
      "nsight-systems/*/*/python/bin/python"
    ];
  };
  postPatch =
    prevAttrs.postPatch or ""
    + ''
      for path in $rmPatterns; do
        rm -r "$path"
      done
    '';
  nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ qt.wrapQtAppsHook ];
  buildInputs = prevAttrs.buildInputs ++ [
    (qt.qtdeclarative or qt.full)
    (qt.qtsvg or qt.full)
    (getOutput "stubs" cuda_cudart)
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    nss
    numactl
    pulseaudio
    qt.qtbase
    qtWaylandPlugins
    rdma-core
    ucx
    wayland
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
  ];

  brokenConditions = prevAttrs.brokenConditions // {
    # Older releases require boost 1.70, which is deprecated in Nixpkgs
    "CUDA too old (<11.8)" = cudaOlder "11.8";
  };

  badPlatformsConditions =
    prevAttrs.badPlatformsConditions
    // utils.mkMissingPackagesBadPlatformsConditions (
      optionalAttrs (versionOlder version "2022.4.2.1") { inherit qt5; }
      // optionalAttrs (versionAtLeast version "2022.4.2.1") { inherit qt6; }
    );
}
