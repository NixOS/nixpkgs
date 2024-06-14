{
  boost178,
  cuda_cudart,
  cudaOlder,
  e2fsprogs,
  gst_all_1,
  lib,
  nss,
  numactl,
  pulseaudio,
  qt5 ? null,
  qt5Packages ? null,
  qt6 ? null,
  qt6Packages ? null,
  rdma-core,
  ucx,
  utils,
  wayland,
  xorg,
}:
prevAttrs:
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.strings) versionOlder versionAtLeast;
  inherit (prevAttrs) version;
  qt = if versionOlder prevAttrs.version "2022.4.2.1" then qt5 else qt6;
  qtPackages = if versionOlder prevAttrs.version "2022.4.2.1" then qt5 else qt6Packages;
  qtwayland = lib.getBin qtPackages.qtwayland;
  qtWaylandPlugins = "${qtwayland}/${qt.qtbase.qtPluginPrefix}";
  inherit (qtPackages)
    qtbase
    qtpositioning
    qtscxml
    qttools
    qtwebengine
    ;
in
{
  allowFHSReferences = true;
  # An ad hoc replacement for
  # https://github.com/ConnorBaker/cuda-redist-find-features/issues/11
  env = prevAttrs.env or { } // {
    rmPatterns = toString [
      "nsight-systems/*/*/lib{arrow,jpeg}*"
      "nsight-systems/*/*/lib{ssl,ssh,crypto}*"
      "nsight-systems/*/*/libboost*"
      "nsight-systems/*/*/libexec"
      "nsight-systems/*/*/libQt6*"
      "nsight-systems/*/*/libstdc*"
      "nsight-systems/*/*/Mesa"
      "nsight-systems/*/*/python/bin/python"
    ];
  };

  postPatch =
    prevAttrs.postPatch or ""
    + ''
      for path in $rmPatterns; do
        rm -r "$path"
      done
    ''
    + ''
      patchShebangs nsight-systems
    '';

  nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ qt.wrapQtAppsHook ];

  buildInputs = prevAttrs.buildInputs ++ [
    (qt.qtdeclarative or qt.full)
    (qt.qtsvg or qt.full)
    boost178
    cuda_cudart.stubs
    e2fsprogs
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    nss
    numactl
    pulseaudio
    qtbase
    qtWaylandPlugins
    qtpositioning
    qtscxml
    qttools
    qtwebengine
    rdma-core
    ucx
    wayland
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
  ];

  postInstall =
    # 1. Move dependencies of nsys, nsys-ui binaries to bin output
    # 2. Fix paths in wrapper scripts
    let
      versionString = utils.majorMinorPatch prevAttrs.version;
    in
    prevAttrs.postInstall or ""
    + ''
      moveToOutput 'nsight-systems/${versionString}/host-linux-*' "''${!outputBin}"
      moveToOutput 'nsight-systems/${versionString}/target-linux-*' "''${!outputBin}"
      substituteInPlace $bin/bin/nsys $bin/bin/nsys-ui \
        --replace-fail 'nsight-systems-#VERSION_RSPLIT#' nsight-systems/${versionString}
      for qtlib in $bin/nsight-systems/${versionString}/host-linux-x64/Plugins/*/libq*.so; do
        qtdir=$(basename $(dirname $qtlib))
        filename=$(basename $qtlib)
        for qtpkgdir in ${
          lib.concatMapStringsSep " " (x: qt6Packages.${x}) [
            "qtbase"
            "qtimageformats"
            "qtsvg"
            "qtwayland"
          ]
        }; do
          if [ -e $qtpkgdir/lib/qt-6/plugins/$qtdir/$filename ]; then
            ln -snf $qtpkgdir/lib/qt-6/plugins/$qtdir/$filename $qtlib
          fi
        done
      done
    '';

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
