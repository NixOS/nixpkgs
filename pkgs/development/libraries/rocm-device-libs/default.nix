{ lib, stdenv
, fetchFromGitHub
, writeScript
, cmake
, clang
, llvm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-device-libs";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-rKMe0B/pkDek/ZU37trnJNa8aqvlwxobPb1+VTx/bJU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang llvm ];

  cmakeFlags = [
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm;${llvm}/lib/cmake/clang"
    "-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'"
    "-DCLANG=${clang}/bin/clang"
  ];

  patches = [ ./cmake.patch ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} -sL "https://api.github.com/repos/RadeonOpenCompute/ROCm-Device-Libs/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocm-device-libs "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
