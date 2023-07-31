final: prev:
let
  inherit (prev) lib pkgs;
in
(lib.filterAttrs (attr: _: (prev ? "${attr}")) {
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

  cuda_nvcc = prev.cuda_nvcc.overrideAttrs (oldAttrs:
    let
      inherit (prev.backendStdenv) cc;
    in
    {
      # Required by cmake's enable_language(CUDA) to build a test program
      # When implementing cross-compilation support: this is
      # final.pkgs.targetPackages.cudaPackages.cuda_cudart
      env.cudartRoot = "${prev.lib.getDev final.cuda_cudart}";

      # Point NVCC at a compatible compiler

      # Desiredata: whenever a package (e.g. magma) adds cuda_nvcc to
      # nativeBuildInputs (offsets `(-1, 0)`), magma should also source the
      # setupCudaHook, i.e. we want it the hook to be propagated into the
      # same nativeBuildInputs.
      #
      # Logically, cuda_nvcc should include the hook in depsHostHostPropagated,
      # so that the final offsets for the propagated hook would be `(-1, 0) +
      # (0, 0) = (-1, 0)`.
      #
      # In practice, TargetTarget appears to work:
      # https://gist.github.com/fd80ff142cd25e64603618a3700e7f82
      depsTargetTargetPropagated = [
        final.setupCudaHook
      ];
    });

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
    nativeBuildInputs = oldAttrs.nativeBuildInputs
    ++ (if (lib.versionOlder prev.nsight_compute.version "2022.2.0")
       then [ pkgs.qt5.wrapQtAppsHook ]
       else [ pkgs.qt6.wrapQtAppsHook ]);
    buildInputs = oldAttrs.buildInputs
    ++ (if (lib.versionOlder prev.nsight_compute.version "2022.2.0")
       then [ pkgs.qt5.qtwebview ]
       else [ pkgs.qt6.qtwebview ]);
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
