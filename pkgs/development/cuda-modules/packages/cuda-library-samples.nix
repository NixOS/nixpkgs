{
  autoAddDriverRunpath,
  backendStdenv,
  cmake,
  cudaMajorMinorVersion,
  cudatoolkit-legacy-runfile,
  fetchFromGitHub,
  lib,
  libcutensor ? null,
}:

let
  rev = "5aab680905d853bce0dbad4c488e4f7e9f7b2302";
  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "CUDALibrarySamples";
    inherit rev;
    sha256 = "0gwgbkq05ygrfgg5hk07lmap7n7ampxv0ha1axrv8qb748ph81xs";
  };
  commonAttrs = {
    version = lib.strings.substring 0 7 rev;
    nativeBuildInputs = [
      autoAddDriverRunpath
      cmake
      cudatoolkit-legacy-runfile
    ];
    buildInputs = [ cudatoolkit-legacy-runfile ];
    postFixup = ''
      for exe in $out/bin/*; do
        addOpenGLRunpath $exe
      done
    '';
    meta = {
      description = "examples of using libraries using CUDA";
      longDescription = ''
        CUDA Library Samples contains examples demonstrating the use of
        features in the math and image processing libraries cuBLAS, cuTENSOR,
        cuSPARSE, cuSOLVER, cuFFT, cuRAND, NPP and nvJPEG.
      '';
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ obsidian-systems-maintenance ] ++ lib.teams.cuda.members;
      # Samples are built around the CUDA Toolkit, which is not available for
      # aarch64. Check for both CUDA version and platform.
      platforms = [ "x86_64-linux" ];
    };
  };
in

{
  cublas = backendStdenv.mkDerivation (
    finalAttrs:
    commonAttrs
    // {
      name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}";
      pname = "cuda-library-samples-cublas";

      src = "${src}/cuBLASLt";
    }
  );

  cusolver = backendStdenv.mkDerivation (
    finalAttrs:
    commonAttrs
    // {
      name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}";
      pname = "cuda-library-samples-cusolver";

      src = "${src}/cuSOLVER";

      sourceRoot = "cuSOLVER/gesv";
    }
  );

  cutensor = backendStdenv.mkDerivation (
    finalAttrs:
    commonAttrs
    // {
      name = "cuda${cudaMajorMinorVersion}-${finalAttrs.pname}";
      pname = "cuda-library-samples-cutensor";

      src = "${src}/cuTENSOR";

      buildInputs = [ libcutensor ];

      cmakeFlags = [ "-DCUTENSOR_EXAMPLE_BINARY_INSTALL_DIR=${builtins.placeholder "out"}/bin" ];

      # CUTENSOR_ROOT is double escaped
      postPatch = ''
        substituteInPlace CMakeLists.txt \
          --replace-fail "\''${CUTENSOR_ROOT}/include" "${libcutensor.dev}/include"
      '';

      CUTENSOR_ROOT = libcutensor;

      meta.broken = libcutensor == null;
    }
  );
}
