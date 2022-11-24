{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, hip
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocmlir";
  rocmVersion = "5.3.3";
  version = finalAttrs.rocmVersion;

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-s/5gAH5vh2tgATZemPP66juQFDg8BR2sipzX2Q6pOOQ=";
  };

  nativeBuildInputs = [
    cmake
    hip
  ];

  buildInputs = [
    python3
  ];

  cmakeFlags = [
    "-DBUILD_FAT_LIBMLIRMIOPEN=ON"
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    rocmVersion="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocMLIR/tags?per_page=2" | jq '.[1].name | split("-") | .[1]' --raw-output)"
    update-source-version rocmlir "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
