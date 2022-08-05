final: prev: let
  inherit (prev) lib pkgs;
in (lib.filterAttrs (attr: _: (prev ? "${attr}")) {
  ### Overrides to fix the components of cudatoolkit-redist

  # Attributes that don't exist in the previous set are removed.
  # That means only overrides can go here, and not new expressions!

  libcufile = prev.libcufile.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
      prev.libcublas
      pkgs.numactl
      pkgs.rdma-core
    ];
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = true;
  });

  libcusolver = final.addBuildInputs prev.libcusolver [
    prev.libcublas
  ];

  cuda_nvprof = prev.cuda_nvprof.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.addOpenGLRunpath ];
    buildInputs = oldAttrs.buildInputs ++ [ prev.cuda_cupti ];
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = true;
  });

  cuda_demo_suite = final.addBuildInputs prev.cuda_demo_suite [
    pkgs.freeglut
    pkgs.libGLU
    pkgs.libglvnd
    pkgs.mesa
    prev.libcufft
    prev.libcurand
  ];

  nsight_compute = prev.nsight_compute.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.qt5.wrapQtAppsHook ];
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.qt5.qtwebview ];
  });

  nsight_systems = prev.nsight_systems.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      pkgs.addOpenGLRunpath
      pkgs.qt5.wrapQtAppsHook
    ];
    buildInputs = oldAttrs.buildInputs ++ [
      pkgs.alsa-lib
      pkgs.e2fsprogs
      pkgs.nss
      pkgs.numactl
      pkgs.pulseaudio
      pkgs.wayland
      pkgs.xorg.libXcursor
      pkgs.xorg.libXdamage
      pkgs.xorg.libXrandr
      pkgs.xorg.libXtst
    ];
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = true;
  });

  nvidia_driver = prev.nvidia_driver.overrideAttrs (oldAttrs: {
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = true;
    # No need to support this package as we have drivers already
    # in linuxPackages.
    meta.broken = true;
  });
})
