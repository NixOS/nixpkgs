{
  _cuda,
  backendStdenv,
  buildRedist,
  cudaAtLeast,
  cudaOlder,
  cudaMajorMinorVersion,
  cuda_cccl,
  lib,
  libnvvm,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_nvcc";

  # NOTE: We restrict cuda_nvcc to a single output to avoid breaking consumers which expect NVCC to be within a single
  # directory structure. This happens partly because NVCC is also home to NVVM.
  outputs = [
    "out"
  ];

  # The nvcc and cicc binaries contain hard-coded references to /usr
  allowFHSReferences = true;

  # Entries here will be in nativeBuildInputs when cuda_nvcc is in nativeBuildInputs
  propagatedBuildInputs = [ backendStdenv.cc ];

  # Patch the nvcc.profile.
  # Syntax:
  # - `=` for assignment,
  # - `?=` for conditional assignment,
  # - `+=` to "prepend",
  # - `=+` to "append".

  # Cf. https://web.archive.org/web/20220912081901/https://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/nvcc.pdf

  # We set all variables with the lowest priority (=+), but we do force
  # nvcc to use the fixed backend toolchain. Cf. comments in
  # backend-stdenv.nix

  # As an example, here's the nvcc.profile for CUDA 11.8-12.4 (yes, that is a leading newline):

  #
  # TOP              = $(_HERE_)/..
  #
  # NVVMIR_LIBRARY_DIR = $(TOP)/$(_NVVM_BRANCH_)/libdevice
  #
  # LD_LIBRARY_PATH += $(TOP)/lib:
  # PATH            += $(TOP)/$(_NVVM_BRANCH_)/bin:$(_HERE_):
  #
  # INCLUDES        +=  "-I$(TOP)/$(_TARGET_DIR_)/include" $(_SPACE_)
  #
  # LIBRARIES        =+ $(_SPACE_) "-L$(TOP)/$(_TARGET_DIR_)/lib$(_TARGET_SIZE_)/stubs" "-L$(TOP)/$(_TARGET_DIR_)/lib$(_TARGET_SIZE_)"
  #
  # CUDAFE_FLAGS    +=
  # PTXAS_FLAGS     +=

  # And here's the nvcc.profile for CUDA 12.5:

  #
  # TOP              = $(_HERE_)/..
  #
  # CICC_PATH        = $(TOP)/nvvm/bin
  # CICC_NEXT_PATH   = $(TOP)/nvvm-next/bin
  # NVVMIR_LIBRARY_DIR = $(TOP)/nvvm/libdevice
  #
  # LD_LIBRARY_PATH += $(TOP)/lib:
  # PATH            += $(CICC_PATH):$(_HERE_):
  #
  # INCLUDES        +=  "-I$(TOP)/$(_TARGET_DIR_)/include" $(_SPACE_)
  #
  # LIBRARIES        =+ $(_SPACE_) "-L$(TOP)/$(_TARGET_DIR_)/lib$(_TARGET_SIZE_)/stubs" "-L$(TOP)/$(_TARGET_DIR_)/lib$(_TARGET_SIZE_)"
  #
  # CUDAFE_FLAGS    +=
  # PTXAS_FLAGS     +=

  postInstall =
    let
      # TODO: Should we also patch the LIBRARIES line's use of $(TOP)/$(_TARGET_DIR_)?
      oldNvvmDir = lib.concatStringsSep "/" (
        [ "$(TOP)" ]
        ++ lib.optionals (cudaOlder "12.5") [ "$(_NVVM_BRANCH_)" ]
        ++ lib.optionals (cudaAtLeast "12.5") [ "nvvm" ]
      );
      newNvvmDir = ''''${!outputBin:?}/nvvm'';
    in
    lib.optionalString finalAttrs.finalPackage.meta.available (
      # From CUDA 13.0, NVVM is available as a separate library and not bundled in the NVCC redist.
      lib.optionalString (cudaOlder "13.0") ''
        nixLog "moving $PWD/nvvm to ''${!outputBin:?} and renaming lib64 to lib"
        moveToOutput "nvvm" "''${!outputBin:?}"
        mv --verbose --no-clobber "${newNvvmDir}/lib64" "${newNvvmDir}/lib"
      ''
      # NVVM is unpacked and made top-level; we cannot make a symlink to it because build systems (like CMake)
      # may take the target and do relative path operations to it.
      + lib.optionalString (cudaAtLeast "13.0") ''
        nixLog "copying ${libnvvm} to ${newNvvmDir} and fixing permissions"
        cp -rv "${libnvvm}" "${newNvvmDir}"
        chmod -Rv u+w "${newNvvmDir}"
      ''
      # Unconditional patching to remove the use of $(_TARGET_SIZE_) since we don't use lib64 in Nixpkgs
      + ''
        nixLog 'removing $(_TARGET_SIZE_) from nvcc.profile'
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail \
            '$(_TARGET_SIZE_)' \
            ""
      ''
      # CUDA 13.0+ introduced
      # SYSTEM_INCLUDES +=  "-isystem" "$(TOP)/$(_TARGET_DIR_)/include/cccl" $(_SPACE_)
      # so we need to make sure to patch the reference to cccl.
      + lib.optionalString (cudaAtLeast "13.0") ''
        nixLog "patching nvcc.profile to include correct path to cccl"
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail \
            '$(TOP)/$(_TARGET_DIR_)/include/cccl' \
            "${lib.getOutput "include" cuda_cccl}/include"
      ''
      # Unconditional patching to switch to the correct include paths.
      # NOTE: _TARGET_DIR_ appears to be used for the target architecture, which is relevant for cross-compilation.
      + ''
        nixLog "patching nvcc.profile to use the correct include paths"
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail \
            '$(TOP)/$(_TARGET_DIR_)/include' \
            "''${!outputInclude:?}/include"
      ''
      # Fixup the nvcc.profile to use the correct paths for NVVM.
      # NOTE: In our replacement substitution, we use double quotes to allow for variable expansion.
      # NOTE: We use a trailing slash only on the NVVM directory replacement to prevent partial matches.
      + ''
        nixLog "patching nvcc.profile to use the correct NVVM paths"
        substituteInPlace "''${!outputBin:?}/bin/nvcc.profile" \
          --replace-fail \
            '${oldNvvmDir}/' \
            "${newNvvmDir}/"

        nixLog "adding ${newNvvmDir} to nvcc.profile"
        cat << EOF >> "''${!outputBin:?}/bin/nvcc.profile"

        # Expose the split-out nvvm
        LIBRARIES =+ \$(_SPACE_) "-L${newNvvmDir}/lib"
        INCLUDES =+ \$(_SPACE_) "-I${newNvvmDir}/include"
        EOF
      ''
      # Add the dependency on backendStdenv.cc to the nvcc.profile.
      + ''
        nixLog "adding backendStdenv.cc to nvcc.profile"
        cat << EOF >> "''${!outputBin:?}/bin/nvcc.profile"

        # Fix a compatible backend compiler
        PATH += "${backendStdenv.cc}/bin":
        EOF
      ''
    );

  brokenAssertions = [
    # TODO(@connorbaker): Build fails on x86 when using pkgsLLVM.
    #  .../include/crt/host_defines.h:67:2:
    #  error: "libc++ is not supported on x86 system"
    #
    #     67 | #error "libc++ is not supported on x86 system"
    #        |  ^
    #
    #  1 error generated.
    #
    #  # --error 0x1 --
    {
      message = "cannot use libc++ on x86_64-linux";
      assertion = backendStdenv.hostNixSystem == "x86_64-linux" -> backendStdenv.cc.libcxx == null;
    }
  ];

  meta = {
    description = "CUDA compiler driver";
    homepage = "https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc";
    mainProgram = "nvcc";

    # TODO: Consider testing whether we in fact use the newer libstdc++
    problems =
      let
        inherit (builtins) filter toJSON;
        inherit (_cuda.db) allSortedCudaCapabilities cudaCapabilityToInfo;
        inherit (lib.lists) intersectLists subtractLists;
        inherit (lib.versions) versionOlder versionAtLeast;
        inherit (lib) flip;

        # NOTE: By virtue of processing a sorted list (allSortedCudaCapabilities), our groups will be sorted.

        architectureSpecificCudaCapabilities = filter (
          cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isArchitectureSpecific
        ) allSortedCudaCapabilities;

        jetsonCudaCapabilities = filter (
          cudaCapability: cudaCapabilityToInfo.${cudaCapability}.isJetson
        ) allSortedCudaCapabilities;

        # Requested Jetson CUDA capabilities.
        requestedJetsonCudaCapabilities = intersectLists jetsonCudaCapabilities backendStdenv.cudaCapabilities;

        # Whether the requested CUDA capabilities include Jetson CUDA capabilities.
        hasJetsonCudaCapability = requestedJetsonCudaCapabilities != [ ];

        # Jetson devices (pre-Thor) cannot be targeted by the same binaries which target non-Jetson devices. While
        # NVIDIA provides both `linux-aarch64` and `linux-sbsa` packages, which both target `aarch64`,
        # they are built with different settings and cannot be mixed.
        preThorJetsonCudaCapabilities = filter (flip versionOlder "10.1") requestedJetsonCudaCapabilities;
        postThorJetsonCudaCapabilities = filter (flip versionAtLeast "10.1") requestedJetsonCudaCapabilities;

        # Remove all known capabilities from the user's list to find unrecognized capabilities.
        unrecognizedCudaCapabilities = subtractLists allSortedCudaCapabilities backendStdenv.cudaCapabilities;

        # Capabilities which are too old for this CUDA version.
        tooOldCudaCapabilities = filter (
          cap:
          let
            # This can be null!
            maybeMax = cudaCapabilityToInfo.${cap}.maxCudaMajorMinorVersion;
          in
          maybeMax != null && lib.versionOlder maybeMax cudaMajorMinorVersion
        ) backendStdenv.cudaCapabilities;

        # Capabilities which are too new for this CUDA version.
        tooNewCudaCapabilities = filter (
          cap: lib.versionOlder cudaMajorMinorVersion cudaCapabilityToInfo.${cap}.minCudaMajorMinorVersion
        ) backendStdenv.cudaCapabilities;
      in
      _cuda.lib._mkMetaProblems [
        {
          kind = "unsupported";
          assertion = backendStdenv.supportedByNvcc;
          message = "Couldn't find a host compiler compatible with NVCC.";
        }
        {
          kind = "broken";
          message = "Requested unrecognized CUDA capabilities: ${toJSON unrecognizedCudaCapabilities}";
          assertion = unrecognizedCudaCapabilities == [ ];
        }
        {
          kind = "unsupported";
          message = "Requested CUDA capabilities which are too old for CUDA ${cudaMajorMinorVersion}: ${toJSON tooOldCudaCapabilities}";
          assertion = tooOldCudaCapabilities == [ ];
        }
        {
          kind = "unsupported";
          message = "Requested CUDA capabilities which are too new for CUDA ${cudaMajorMinorVersion}: ${toJSON tooNewCudaCapabilities}";
          assertion = tooNewCudaCapabilities == [ ];
        }
        {
          kind = "unsupported";
          message =
            "Requested Jetson CUDA capabilities (${toJSON requestedJetsonCudaCapabilities}) require "
            + "hostPlatform (${backendStdenv.hostNixSystem}) to be aarch64-linux";
          assertion = hasJetsonCudaCapability -> backendStdenv.hostNixSystem == "aarch64-linux";
        }
        {
          kind = "unsupported";
          message =
            "Requested pre-Thor (10.1) Jetson CUDA capabilities (${toJSON preThorJetsonCudaCapabilities}) cannot be "
            + "specified with other capabilities (${toJSON (subtractLists preThorJetsonCudaCapabilities backendStdenv.cudaCapabilities)})";
          assertion =
            # If there are preThorJetsonCudaCapabilities, they must be the only requested capabilities.
            preThorJetsonCudaCapabilities != [ ]
            -> preThorJetsonCudaCapabilities == backendStdenv.cudaCapabilities;
        }
        {
          kind = "unsupported";
          message =
            "Requested pre-Thor (10.1) Jetson CUDA capabilities (${toJSON preThorJetsonCudaCapabilities}) require "
            + "computed NVIDIA hostRedistSystem (${backendStdenv.hostRedistSystem}) to be linux-aarch64";
          assertion =
            preThorJetsonCudaCapabilities != [ ] -> backendStdenv.hostRedistSystem == "linux-aarch64";
        }
        {
          kind = "unsupported";
          message =
            "Requested post-Thor (10.1) Jetson CUDA capabilities (${toJSON postThorJetsonCudaCapabilities}) require "
            + "computed NVIDIA hostRedistSystem (${backendStdenv.hostRedistSystem}) to be linux-sbsa";
          assertion = postThorJetsonCudaCapabilities != [ ] -> backendStdenv.hostRedistSystem == "linux-sbsa";
        }
      ];
  };
})
