{
  lib,
  buildPythonPackage,
  cmake,
  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  fetchFromGitHub,
  nanobind,
  ninja,
  setuptools,
  torch,
  comfyui,
  symlinkJoin,
}:

let
  inherit (torch) cudaPackages;
  inherit (torch) rocmPackages;
  rocm-sdk = symlinkJoin {
    name = "rocm-merged";
    paths = with rocmPackages; [
      clr
      rocm-comgr
      rocm-device-libs
      rocm-runtime
    ];
  };
  supportedHIPTargets = [
    # upstream defines this list programatically
    "gfx1030"
    "gfx1031"
    "gfx1032"
    "gfx1033"
    "gfx1034"
    "gfx1035"
    "gfx1036"
    "gfx1100"
    "gfx1101"
    "gfx1102"
    "gfx1103"
    "gfx1150"
    "gfx1151"
    "gfx1152"
    "gfx1153"
    "gfx1200"
    "gfx1201"
  ];
  rocmGpuTargets = rocmPackages.clr.selectGpuTargets { supported = supportedHIPTargets; };
in
buildPythonPackage (finalAttrs: {
  pname = "comfy-kitchen";
  version = "0.2.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "comfy-kitchen";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-apa7N9Y0bt4fpbMTP0qRUC0QnMuJvoxoCOeWONWCExo=";
  };

  buildInputs =
    lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart
        libcublas
      ]
    )
    ++ lib.optionals rocmSupport [ rocm-sdk ];

  build-system = [
    cmake
    nanobind
    ninja
    setuptools
  ];

  dependencies = [ torch ];

  dontUseCmakeConfigure = true;

  pypaBuildFlags =
    if cudaSupport || rocmSupport then
      lib.optionals cudaSupport [
        ''--config-setting=--cuda-archs="${
          lib.concatMapStringsSep ";" cudaPackages.flags.dropDots torch.cudaCapabilities
        }"''
      ]
      ++ lib.optionals rocmSupport [
        "-C--global-option=--hip"
      ]
    else
      [ "-C--global-option=--no-cuda" ];

  env =
    lib.optionalAttrs cudaSupport {
      CUDA_HOME = cudaPackages.cuda_nvcc;
    }
    // lib.optionalAttrs rocmSupport {
      ROCM_HOME = rocm-sdk;
      COMFY_HIP_ARCHS = lib.warnIf (rocmGpuTargets == [ ]) ''
        Building python library comfy-kitchen rocm support without a supported gpu target.
        Supported cards include ${lib.concatStringsSep ", " supportedHIPTargets}
      '' (lib.concatStringsSep ";" rocmGpuTargets);
    };

  # Upstream tests exercise the CUDA/Triton kernel backends; this build
  # might use BUILD_NO_CUDA = True, so those backends would be unavailable
  # and additionally the nix sandbox would prevent it.
  doCheck = false;

  pythonImportsCheck = [ "comfy_kitchen" ];

  meta = {
    description = "Fast kernel library for ComfyUI with multiple compute backends";
    homepage = "https://github.com/Comfy-Org/comfy-kitchen";
    license = lib.licenses.asl20;
    inherit (comfyui.meta) maintainers;
  };
})
