{
  _cuda,
  backendStdenv,
  buildRedist,
  setupCudaHook,
  cudaAtLeast,
  cudaOlder,
  cuda_cccl,
  lib,
  libnvvm,
  makeBinaryWrapper,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_nvcc";

  # NOTE: We restrict cuda_nvcc to a single output to avoid breaking consumers which expect NVCC to be within a single
  # directory structure. This happens partly because NVCC is also home to NVVM.
  outputs = [
    "out"
    "bin"
    "lib"
    "dev"
    "include"
  ];

  # The nvcc and cicc binaries contain hard-coded references to /usr
  allowFHSReferences = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # Entries here will be in nativeBuildInputs when cuda_nvcc is in nativeBuildInputs
  propagatedBuildInputs = [ setupCudaHook ];

  # We create nvcc.profile explicitly to avoid the need to do complicated, in-place modifications.
  # Cf. https://web.archive.org/web/20220912081901/https://developer.download.nvidia.com/compute/DevZone/docs/html/C/doc/nvcc.pdf
  postInstall =
    # From CUDA 13.0, NVVM is available as a separate library and not bundled in the NVCC redist.
    lib.optionalString (cudaOlder "13.0") ''
      nixLog "moving $PWD/nvvm to ''${!outputBin:?} and renaming lib64 to lib"
      moveToOutput "nvvm" "''${!outputBin:?}"
      mv --verbose --no-clobber "''${!outputBin:?}/nvvm/lib64" "''${!outputBin:?}/nvvm/lib"
    ''
    # NVVM is unpacked and made top-level; we cannot make a symlink to it because build systems (like CMake)
    # may take the target and do relative path operations to it.
    + lib.optionalString (cudaAtLeast "13.0") ''
      nixLog "copying ${libnvvm} to ''${!outputBin:?}/nvvm and fixing permissions"
      cp -rv "${libnvvm}" "''${!outputBin:?}/nvvm"
      chmod -Rv u+w "''${!outputBin:?}/nvvm"
    ''
    # Add the dependency on backendStdenv.cc to the nvcc.profile.
    # NOTE: NVCC explodes in horrifying fashion if GCC is not on PATH -- it fails even before
    # reading nvcc.profile!
    + ''
      nixLog "wrapping nvcc to add backendStdenv.cc to its PATH"

      wrapProgramBinary \
        "''${!outputBin:?}/bin/nvcc" \
        --prefix PATH : ${lib.makeBinPath [ backendStdenv.cc ]}
    ''
    # Write the nvcc.profile
    # TODO(@connorbaker): Can this be modified to work with multiple-output NVVM?
    # TODO(@connorbaker): Do any of these need to be set?
    # - TOP
    # - LD_LIBRARY_PATH
    # NOTE: CICC_PATH and NVVMIR_LIBRARY_DIR must be set.
    # NOTE: CICC_PATH, NVVMIR_LIBRARY_DIR, and compiler-bindir cannot be quoted since they are interpreted literally.
    + ''
      nixLog "writing ''${!outputBin:?}/bin/nvcc.profile"
      cat << EOF > "''${!outputBin:?}/bin/nvcc.profile"
      # Add NVCC's components
      PATH      =+ :"''${!outputBin:?}/bin"
      INCLUDES  =+ \$(_SPACE_) "-I''${!outputInclude:?}/include"
      LIBRARIES =+ \$(_SPACE_) "-L''${!outputLib:?}/lib"

      # Set the directory NVCC will search for host compilers
      compiler-bindir = ${lib.getBin backendStdenv.cc}/bin

      # Add NVVM's components
      CICC_PATH          = ''${!outputBin:?}/nvvm/bin
      NVVMIR_LIBRARY_DIR = ''${!outputBin:?}/nvvm/libdevice
      PATH               =+ :"''${!outputBin:?}/nvvm/bin"
      INCLUDES           =+ \$(_SPACE_) "-I''${!outputBin:?}/nvvm/include"
      LIBRARIES          =+ \$(_SPACE_) "-L''${!outputBin:?}/nvvm/lib"

      # Add CCCL's components
      SYSTEM_INCLUDES =+ \$(_SPACE_) "-isystem" "${lib.getInclude cuda_cccl}/cccl"

      # Additional flags, etc.
      CUDAFE_FLAGS =+
      PTXAS_FLAGS  =+
      EOF
    '';

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
  };
})
