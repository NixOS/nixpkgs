{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, clang
, git
, libxml2
, libedit
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocmlir";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocMLIR";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-MokE7Ej8mLHTQeLYvKr7PPlsNG6ul91fqfXDlGu5JpI=";
  };

  nativeBuildInputs = [
    cmake
    clang
  ];

  buildInputs = [
    git
    libxml2
    libedit
    python3
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
    "-DBUILD_FAT_LIBROCKCOMPILER=ON"
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
      -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocMLIR/tags?per_page=2" | jq '.[1].name | split("-") | .[1]' --raw-output)"
    update-source-version rocmlir "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != clang.version;
  };
})
