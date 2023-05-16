final: prev:
let
  inherit (prev) lib pkgs;
<<<<<<< HEAD
  cudaVersionOlder = lib.versionOlder final.cudaVersion;
  cudaVersionAtLeast = lib.versionAtLeast final.cudaVersion;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
(lib.filterAttrs (attr: _: (prev ? "${attr}")) {
  ### Overrides to fix the components of cudatoolkit-redist

  # Attributes that don't exist in the previous set are removed.
  # That means only overrides can go here, and not new expressions!

  libcufile = prev.libcufile.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
<<<<<<< HEAD
      final.libcublas.lib
=======
      prev.libcublas
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      pkgs.numactl
      pkgs.rdma-core
    ];
    # libcuda needs to be resolved during runtime
<<<<<<< HEAD
    autoPatchelfIgnoreMissingDeps =
      ["libcuda.so.1"]
      # Before 12.0 libcufile depends on itself for some reason.
      ++ lib.optionals (cudaVersionOlder "12.0") [
        "libcufile.so.0"
      ];
  });

  libcusolver = final.addBuildInputs prev.libcusolver (
    # Always depends on this
    [final.libcublas.lib]
    # Dependency from 12.0 and on
    ++ lib.optionals (cudaVersionAtLeast "12.0") [
      final.libnvjitlink.lib
    ]
    # Dependency from 12.1 and on
    ++ lib.optionals (cudaVersionAtLeast "12.1") [
      final.libcusparse.lib
    ]
  );

  libcusparse = final.addBuildInputs prev.libcusparse (
    lib.optionals (cudaVersionAtLeast "12.0") [
      final.libnvjitlink.lib
    ]
  );

  cuda_gdb = final.addBuildInputs prev.cuda_gdb (
    # x86_64 only needs gmp from 12.0 and on
    lib.optionals (cudaVersionAtLeast "12.0") [
      pkgs.gmp
    ]
  );

  cuda_nvcc = prev.cuda_nvcc.overrideAttrs (_: {
    # Required by cmake's enable_language(CUDA) to build a test program
    # When implementing cross-compilation support: this is
    # final.pkgs.targetPackages.cudaPackages.cuda_cudart
    env = {
      # Given the multiple-outputs each CUDA redist has, we can specify the exact components we
      # need from the package. CMake requires:
      # - the cuda_runtime.h header, which is in the dev output
      # - the dynamic library, which is in the lib output
      # - the static library, which is in the static output
      cudartInclude = "${final.cuda_cudart.dev}";
      cudartLib = "${final.cuda_cudart.lib}";
      cudartStatic = "${final.cuda_cudart.static}";
    };

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
    buildInputs = oldAttrs.buildInputs ++ [ final.cuda_cupti.lib ];
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = ["libcuda.so.1"];
=======
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
      # Point NVCC at a compatible compiler
      # FIXME: non-redist cudatoolkit copy-pastes this code

      # For CMake-based projects:
      # https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
      # https://cmake.org/cmake/help/latest/envvar/CUDAHOSTCXX.html
      # https://cmake.org/cmake/help/latest/variable/CMAKE_CUDA_HOST_COMPILER.html

      # For non-CMake projects:
      # We prepend --compiler-bindir to nvcc flags.
      # Downstream packages can override these, because NVCC
      # uses the last --compiler-bindir it gets on the command line.
      # FIXME: this results in "incompatible redefinition" warnings.
      # https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#compiler-bindir-directory-ccbin
      # NOTE: We unconditionally set -Xfatbin=-compress-all, which reduces the size of the
      #   compiled binaries. If binaries grow over 2GB, they will fail to link. This is a problem
      #   for us, as the default set of CUDA capabilities we build can regularly cause this to
      #   occur (for example, with Magma).
      postInstall = (oldAttrs.postInstall or "") + ''
        mkdir -p $out/nix-support
        cat <<EOF >> $out/nix-support/setup-hook
        cmakeFlags+=' -DCUDA_HOST_COMPILER=${cc}/bin'
        cmakeFlags+=' -DCMAKE_CUDA_HOST_COMPILER=${cc}/bin'
        if [ -z "\''${CUDAHOSTCXX-}" ]; then
          export CUDAHOSTCXX=${cc}/bin;
        fi
        export NVCC_PREPEND_FLAGS+=' --compiler-bindir=${cc}/bin -Xfatbin=-compress-all'
        EOF
      '';
    });

  cuda_nvprof = prev.cuda_nvprof.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.addOpenGLRunpath ];
    buildInputs = oldAttrs.buildInputs ++ [ prev.cuda_cupti ];
    # libcuda needs to be resolved during runtime
    autoPatchelfIgnoreMissingDeps = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  });

  cuda_demo_suite = final.addBuildInputs prev.cuda_demo_suite [
    pkgs.freeglut
    pkgs.libGLU
    pkgs.libglvnd
    pkgs.mesa
<<<<<<< HEAD
    final.libcufft.lib
    final.libcurand.lib
=======
    prev.libcufft
    prev.libcurand
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    autoPatchelfIgnoreMissingDeps = ["libcuda.so.1"];
=======
    autoPatchelfIgnoreMissingDeps = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # No need to support this package as we have drivers already
    # in linuxPackages.
    meta.broken = true;
  });
})
