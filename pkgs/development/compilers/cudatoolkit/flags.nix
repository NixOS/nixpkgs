{ config
, lib
, cudatoolkit
}:
let

  # Flags are determined based on your CUDA toolkit by default.  You may benefit
  # from improved performance, reduced file size, or greater hardware suppport by
  # passing a configuration based on your specific GPU environment.
  #
  # config.cudaCapabilities: list of hardware generations to support (e.g., "8.0")
  # config.cudaForwardCompat: bool for compatibility with future GPU generations
  #
  # Please see the accompanying documentation or https://github.com/NixOS/nixpkgs/pull/205351

  defaultCudaCapabilities = rec {
    cuda9 = [
      "3.0"
      "3.5"
      "5.0"
      "5.2"
      "6.0"
      "6.1"
      "7.0"
    ];

    cuda10 = cuda9 ++ [
      "7.5"
    ];

    cuda11 = [
      "3.5"
      "5.0"
      "5.2"
      "6.0"
      "6.1"
      "7.0"
      "7.5"
      "8.0"
      "8.6"
    ];

  };

  cudaMicroarchitectureNames = {
    "3" = "Kepler";
    "5" = "Maxwell";
    "6" = "Pascal";
    "7" = "Volta";
    "8" = "Ampere";
    "9" = "Hopper";
  };

  defaultCudaArchList = defaultCudaCapabilities."cuda${lib.versions.major cudatoolkit.version}";
  cudaRealCapabilities = config.cudaCapabilities or defaultCudaArchList;
  capabilitiesForward = "${lib.last cudaRealCapabilities}+PTX";

  dropDot = ver: builtins.replaceStrings ["."] [""] ver;

  archMapper = feat: map (ver: "${feat}_${dropDot ver}");
  gencodeMapper = feat: map (ver: "-gencode=arch=compute_${dropDot ver},code=${feat}_${dropDot ver}");
  cudaRealArchs = archMapper "sm" cudaRealCapabilities;
  cudaPTXArchs = archMapper "compute" cudaRealCapabilities;
  cudaArchs = cudaRealArchs ++ [ (lib.last cudaPTXArchs) ];

  cudaArchNames = lib.unique (map (v: cudaMicroarchitectureNames.${lib.versions.major v}) cudaRealCapabilities);
  cudaCapabilities = cudaRealCapabilities ++ lib.optional (config.cudaForwardCompat or true) capabilitiesForward;
  cudaGencode = gencodeMapper "sm" cudaRealCapabilities ++ lib.optionals (config.cudaForwardCompat or true) (gencodeMapper "compute" [ (lib.last cudaPTXArchs) ]);

  cudaCapabilitiesCommaString = lib.strings.concatStringsSep "," cudaCapabilities;
  cudaCapabilitiesSemiColonString = lib.strings.concatStringsSep ";" cudaCapabilities;
  cudaRealCapabilitiesCommaString = lib.strings.concatStringsSep "," cudaRealCapabilities;

in
{
   inherit cudaArchs cudaArchNames cudaCapabilities cudaCapabilitiesCommaString cudaCapabilitiesSemiColonString
     cudaRealCapabilities cudaRealCapabilitiesCommaString cudaGencode cudaRealArchs cudaPTXArchs;
}
