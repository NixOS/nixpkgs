{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocblas
, rocsparse
, rocprim
, rocrand
, hip
, openmp
, openmpi
, git
, buildExamples ? false
, gpuTargets ? null # gpuTargets = [ "gfx803" "gfx900:xnack-" "gfx906:xnack-" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocalution";
  repoVersion = "2.1.0";
  rocmVersion = "5.3.3";
  version = "${finalAttrs.repoVersion}-${finalAttrs.rocmVersion}";

  outputs = [
    "out"
  ] ++ lib.optionals buildExamples [
    "example"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocALUTION";
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-RO9kTN4BXPlbWjs78TjFe3RuOj6WxiKxfrC0uCLtp2g=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    rocblas
    rocsparse
    rocprim
    rocrand
    openmp
    openmpi
    git
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DSUPPORT_MPI=ON"
    "-DROCM_PATH=${hip}"
    "-DHIP_ROOT_DIR=${hip}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (gpuTargets != null) [
    "-DGPU_TARGETS=${lib.strings.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildExamples [
    "-DBUILD_EXAMPLES=ON"
  ];

  #postInstall = lib.optionalString buildExamples ''
  #  mkdir -p $example/bin
  #  mv $out/bin/example_* $example/bin
  #  rmdir $out/bin
  #'';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    json="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocALUTION/releases?per_page=1")"
    repoVersion="$(echo "$json" | jq '.[0].name | split(" ") | .[1]' --raw-output)"
    rocmVersion="$(echo "$json" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocalution "$repoVersion" --ignore-same-hash --version-key=repoVersion
    update-source-version rocalution "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "Iterative sparse solvers for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocALUTION";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
