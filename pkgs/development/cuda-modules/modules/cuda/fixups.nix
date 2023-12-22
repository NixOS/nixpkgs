# Attribute set where each package name maps to a function which, when `callPackage` is called on it,
# returns a function to be provided to `overrideAttrs` to override the attributes of that package.
# NOTE: Unless a package is always available, do not take it by name in the callPackage arguments;
# instead, take cudaPackages and use the package you need within a guard (e.g., cudaVersionAtLeast).
{
  libcufile =
    {
      cudaVersionOlder,
      lib,
      libcublas,
      numactl,
      rdma-core,
    }:
    prevAttrs:
    (prevAttrs: {
      buildInputs = prevAttrs.buildInputs ++ [
        libcublas.lib
        numactl
        rdma-core
      ];
      # Before 11.7 libcufile depends on itself for some reason.
      env.autoPatchelfIgnoreMissingDeps =
        prevAttrs.env.autoPatchelfIgnoreMissingDeps
        + lib.optionalString (cudaVersionOlder "11.7") " libcufile.so.0";
    });

  libcusolver =
    {
      cudaPackages,
      cudaVersionAtLeast,
      lib,
      libcublas,
    }:
    prevAttrs: {
      buildInputs =
        prevAttrs.buildInputs
        # Always depends on this
        ++ [ libcublas.lib ]
        # Dependency from 12.0 and on
        ++ lib.optionals (cudaVersionAtLeast "12.0") [ cudaPackages.libnvjitlink.lib ]
        # Dependency from 12.1 and on
        ++ lib.optionals (cudaVersionAtLeast "12.1") [ cudaPackages.libcusparse.lib ];
    };

  libcusparse =
    {
      cudaPackages,
      cudaVersionAtLeast,
      lib,
    }:
    prevAttrs: {
      buildInputs =
        prevAttrs.buildInputs
        ++ lib.optionals (cudaVersionAtLeast "12.0") [ cudaPackages.libnvjitlink.lib ];
    };

  cuda_compat =
    { flags }:
    prevAttrs: {
      env.autoPatchelfIgnoreMissingDeps =
        prevAttrs.env.autoPatchelfIgnoreMissingDeps + " libnvrm_gpu.so libnvrm_mem.so libnvdla_runtime.so";
      # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
      brokenConditions = prevAttrs.brokenConditions // {
        "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices" = !flags.isJetsonBuild;
      };
    };

  cuda_gdb =
    {
      cudaVersionAtLeast,
      gmp,
      lib,
    }:
    prevAttrs: {
      buildInputs =
        prevAttrs.buildInputs
        # x86_64 only needs gmp from 12.0 and on
        ++ lib.optionals (cudaVersionAtLeast "12.0") [ gmp ];
    };

  cuda_nvcc =
    { setupCudaHook }:
    prevAttrs: {
      propagatedBuildInputs = [ setupCudaHook ];

      meta = (prevAttrs.meta or { }) // {
        mainProgram = "nvcc";
      };
    };

  cuda_nvprof =
    { cuda_cupti }: prevAttrs: { buildInputs = prevAttrs.buildInputs ++ [ cuda_cupti.lib ]; };

  cuda_demo_suite =
    {
      freeglut,
      libcufft,
      libcurand,
      libGLU,
      libglvnd,
      mesa,
    }:
    prevAttrs: {
      buildInputs = prevAttrs.buildInputs ++ [
        freeglut
        libcufft.lib
        libcurand.lib
        libGLU
        libglvnd
        mesa
      ];
    };

  nsight_compute =
    {
      lib,
      qt5,
      qt6,
    }:
    prevAttrs: {
      nativeBuildInputs =
        prevAttrs.nativeBuildInputs
        ++ lib.optionals (lib.versionOlder prevAttrs.version "2022.2.0") [ qt5.wrapQtAppsHook ]
        ++ lib.optionals (lib.versionAtLeast prevAttrs.version "2022.2.0") [ qt6.wrapQtAppsHook ];
      buildInputs =
        prevAttrs.buildInputs
        ++ lib.optionals (lib.versionOlder prevAttrs.version "2022.2.0") [ qt5.qtwebview ]
        ++ lib.optionals (lib.versionAtLeast prevAttrs.version "2022.2.0") [ qt6.qtwebview ];
    };

  nsight_systems =
    {
      alsa-lib,
      e2fsprogs,
      lib,
      nss,
      numactl,
      pulseaudio,
      qt5,
      qt6,
      wayland,
      xorg,
    }:
    prevAttrs: {
      nativeBuildInputs =
        prevAttrs.nativeBuildInputs
        ++ lib.optionals (lib.versionOlder prevAttrs.version "2022.2.0") [ qt5.wrapQtAppsHook ]
        ++ lib.optionals (lib.versionAtLeast prevAttrs.version "2022.2.0") [ qt6.wrapQtAppsHook ];
      buildInputs =
        prevAttrs.buildInputs
        ++ [
          alsa-lib
          e2fsprogs
          nss
          numactl
          pulseaudio
          wayland
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXrandr
          xorg.libXtst
        ]
        ++ lib.optionals (lib.versionOlder prevAttrs.version "2022.2.0") [ qt5.qtwebview ]
        ++ lib.optionals (lib.versionAtLeast prevAttrs.version "2022.2.0") [ qt6.qtwebview ];
    };

  nvidia_driver =
    { }:
    {
      # No need to support this package as we have drivers already
      # in linuxPackages.
      meta.broken = true;
    };
}
