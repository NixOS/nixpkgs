{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, rocm-device-libs
, clang
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clang-ocl";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "clang-ocl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-uMSvcVJj+me2E+7FsXZ4l4hTcK6uKEegXpkHGcuist0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clang
  ];

  buildInputs = [
    rocm-device-libs
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
      -sL "https://api.github.com/repos/RadeonOpenCompute/clang-ocl/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version clang-ocl "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "OpenCL compilation with clang compiler";
    homepage = "https://github.com/RadeonOpenCompute/clang-ocl";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != clang.version;
  };
})
