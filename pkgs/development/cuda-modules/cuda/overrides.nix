{
  cudaVersion,
  lib,
  addDriverRunpath,
}:
let
  inherit (lib) attrsets lists strings;
  # cudaVersionOlder : Version -> Boolean
  cudaVersionOlder = strings.versionOlder cudaVersion;
  # cudaVersionAtLeast : Version -> Boolean
  cudaVersionAtLeast = strings.versionAtLeast cudaVersion;

  addBuildInputs =
    drv: buildInputs:
    drv.overrideAttrs (prevAttrs: {
      buildInputs = prevAttrs.buildInputs ++ buildInputs;
    });
in
# NOTE: Filter out attributes that are not present in the previous version of
# the package set. This is necessary to prevent the appearance of attributes
# like `cuda_nvcc` in `cudaPackages_10_0, which predates redistributables.
final: prev:
attrsets.filterAttrs (attr: _: (builtins.hasAttr attr prev)) {
  libcufile = prev.libcufile.overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs ++ [
      final.libcublas.lib
      final.pkgs.numactl
      final.pkgs.rdma-core
    ];
    # Before 11.7 libcufile depends on itself for some reason.
    autoPatchelfIgnoreMissingDeps =
      prevAttrs.autoPatchelfIgnoreMissingDeps
      ++ lists.optionals (cudaVersionOlder "11.7") [ "libcufile.so.0" ];
  });

  libcusolver = addBuildInputs prev.libcusolver (
    # Always depends on this
    [ final.libcublas.lib ]
    # Dependency from 12.0 and on
    ++ lists.optionals (cudaVersionAtLeast "12.0") [ final.libnvjitlink.lib ]
    # Dependency from 12.1 and on
    ++ lists.optionals (cudaVersionAtLeast "12.1") [ final.libcusparse.lib ]
  );

  libcusparse = addBuildInputs prev.libcusparse (
    lists.optionals (cudaVersionAtLeast "12.0") [ final.libnvjitlink.lib ]
  );

  cuda_cudart = prev.cuda_cudart.overrideAttrs (prevAttrs: {
    # Remove once cuda-find-redist-features has a special case for libcuda
    outputs =
      prevAttrs.outputs
      ++ lists.optionals (!(builtins.elem "stubs" prevAttrs.outputs)) [ "stubs" ];

    allowFHSReferences = false;

    # The libcuda stub's pkg-config doesn't follow the general pattern:
    postPatch =
      prevAttrs.postPatch or ""
      + ''
        while IFS= read -r -d $'\0' path ; do
          sed -i \
            -e "s|^libdir\s*=.*/lib\$|libdir=''${!outputLib}/lib/stubs|" \
            -e "s|^Libs\s*:\(.*\)\$|Libs: \1 -Wl,-rpath,${addDriverRunpath.driverLink}/lib|" \
            "$path"
        done < <(find -iname 'cuda-*.pc' -print0)
      ''
      + ''
        # Namelink may not be enough, add a soname.
        # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/25536
        if [[ -f lib/stubs/libcuda.so && ! -f lib/stubs/libcuda.so.1 ]] ; then
          ln -s libcuda.so lib/stubs/libcuda.so.1
        fi
      '';

    postFixup =
      prevAttrs.postFixup or ""
      + ''
        moveToOutput lib/stubs "$stubs"
        ln -s "$stubs"/lib/stubs/* "$stubs"/lib/
        ln -s "$stubs"/lib/stubs "''${!outputLib}/lib/stubs"
      '';
  });

  cuda_compat = prev.cuda_compat.overrideAttrs (prevAttrs: {
    autoPatchelfIgnoreMissingDeps = prevAttrs.autoPatchelfIgnoreMissingDeps ++ [
      "libnvrm_gpu.so"
      "libnvrm_mem.so"
      "libnvdla_runtime.so"
    ];
    # `cuda_compat` only works on aarch64-linux, and only when building for Jetson devices.
    badPlatformsConditions = prevAttrs.badPlatformsConditions // {
      "Trying to use cuda_compat on aarch64-linux targeting non-Jetson devices" =
        !final.flags.isJetsonBuild;
    };
  });

  cuda_gdb = addBuildInputs prev.cuda_gdb (
    # x86_64 only needs gmp from 12.0 and on
    lists.optionals (cudaVersionAtLeast "12.0") [ final.pkgs.gmp ]
  );

  cuda_nvcc = prev.cuda_nvcc.overrideAttrs (
    oldAttrs:
    let
      # This replicates the logic in stdenvAdapters.useLibsFrom, except we use
      # gcc from pkgsHostTarget and not from buildPackages.
      ccForLibs-wrapper = final.pkgs.stdenv.cc;
      gccMajorVersion = final.nvccCompatibilities.${cudaVersion}.gccMaxMajorVersion;
      cc = final.pkgs.wrapCCWith {
        cc = final.pkgs."gcc${gccMajorVersion}".cc;
        useCcForLibs = true;
        gccForLibs = ccForLibs-wrapper.cc;
      };
    in
    {

      outputs = oldAttrs.outputs ++ lists.optionals (!(builtins.elem "lib" oldAttrs.outputs)) [ "lib" ];

      # Patch the nvcc.profile.
      # Syntax:
      # - `=` for assignment,
      # - `?=` for conditional assignment,
      # - `+=` to "prepend",
      # - `=+` to "append".

      # Cf. https://web.archive.org/web/20230308044351/https://arcb.csc.ncsu.edu/~mueller/cluster/nvidia/2.0/nvcc_2.0.pdf

      # We set all variables with the lowest priority (=+), but we do force
      # nvcc to use the fixed backend toolchain. Cf. comments in
      # backend-stdenv.nix

      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          substituteInPlace bin/nvcc.profile \
            --replace \
              '$(TOP)/lib' \
              "''${!outputLib}/lib" \
            --replace \
              '$(TOP)/$(_NVVM_BRANCH_)' \
              "''${!outputBin}/nvvm" \
            --replace \
              '$(TOP)/$(_TARGET_DIR_)/include' \
              "''${!outputDev}/include"

          cat << EOF >> bin/nvcc.profile

          # Fix a compatible backend compiler
          PATH += ${lib.getBin cc}/bin:

          # Expose the split-out nvvm
          LIBRARIES =+ -L''${!outputBin}/nvvm/lib
          INCLUDES =+ -I''${!outputBin}/nvvm/include

          # Expose cudart and the libcuda stubs
          LIBRARIES =+ -L$static/lib" "-L${final.cuda_cudart.lib}/lib -L${final.cuda_cudart.lib}/lib/stubs
          INCLUDES =+ -I${final.cuda_cudart.dev}/include
          EOF
        '';

      propagatedBuildInputs = [ final.setupCudaHook ];

      postInstall =
        (oldAttrs.postInstall or "")
        + ''
          moveToOutput "nvvm" "''${!outputBin}"
        '';

      # The nvcc and cicc binaries contain hard-coded references to /usr
      allowFHSReferences = true;

      meta = (oldAttrs.meta or { }) // {
        mainProgram = "nvcc";
      };
    }
  );

  cuda_nvprof = prev.cuda_nvprof.overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs ++ [ final.cuda_cupti.lib ];
  });

  cuda_demo_suite = addBuildInputs prev.cuda_demo_suite [
    final.pkgs.freeglut
    final.pkgs.libGLU
    final.pkgs.libglvnd
    final.pkgs.mesa
    final.libcufft.lib
    final.libcurand.lib
  ];

  nsight_compute = prev.nsight_compute.overrideAttrs (prevAttrs: {
    nativeBuildInputs =
      prevAttrs.nativeBuildInputs
      ++ (
        if (strings.versionOlder prev.nsight_compute.version "2022.2.0") then
          [ final.pkgs.qt5.wrapQtAppsHook ]
        else
          [ final.pkgs.qt6.wrapQtAppsHook ]
      );
    buildInputs =
      prevAttrs.buildInputs
      ++ (
        if (strings.versionOlder prev.nsight_compute.version "2022.2.0") then
          [ final.pkgs.qt5.qtwebview ]
        else
          [ final.pkgs.qt6.qtwebview ]
      );
  });

  nsight_systems = prev.nsight_systems.overrideAttrs (
    prevAttrs:
    let
      qt = if lib.versionOlder prevAttrs.version "2022.4.2.1" then final.pkgs.qt5 else final.pkgs.qt6;
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
      env.rmPatterns = toString [
        "nsight-systems/*/*/libQt*"
        "nsight-systems/*/*/libstdc*"
        "nsight-systems/*/*/libboost*"
        "nsight-systems/*/*/lib{ssl,ssh,crypto}*"
        "nsight-systems/*/*/lib{arrow,jpeg}*"
        "nsight-systems/*/*/Mesa"
        "nsight-systems/*/*/python/bin/python"
        "nsight-systems/*/*/libexec"
        "nsight-systems/*/*/Plugins"
      ];
      postPatch =
        prevAttrs.postPatch or ""
        + ''
          for path in $rmPatterns ; do
            rm -r "$path"
          done
        '';
      nativeBuildInputs = prevAttrs.nativeBuildInputs ++ [ qt.wrapQtAppsHook ];
      buildInputs = prevAttrs.buildInputs ++ [
        final.cuda_cudart.stubs
        final.pkgs.alsa-lib
        final.pkgs.boost178
        final.pkgs.e2fsprogs
        final.pkgs.gst_all_1.gst-plugins-base
        final.pkgs.gst_all_1.gstreamer
        final.pkgs.nss
        final.pkgs.numactl
        final.pkgs.pulseaudio
        final.pkgs.rdma-core
        final.pkgs.ucx
        final.pkgs.wayland
        final.pkgs.xorg.libXcursor
        final.pkgs.xorg.libXdamage
        final.pkgs.xorg.libXrandr
        final.pkgs.xorg.libXtst
        qt.qtbase
        (qt.qtdeclarative or qt.full)
        (qt.qtsvg or qt.full)
        qtWaylandPlugins
      ];

      # Older releases require boost 1.70 deprecated in Nixpkgs
      meta.broken = prevAttrs.meta.broken or false || lib.versionOlder final.cudaVersion "11.8";
    }
  );

  nvidia_driver = prev.nvidia_driver.overrideAttrs {
    # No need to support this package as we have drivers already
    # in linuxPackages.
    meta.broken = true;
  };
}
