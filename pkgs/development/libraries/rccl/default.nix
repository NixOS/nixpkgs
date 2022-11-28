{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocm-smi
, hip
, gtest
, chrpath
, buildTests ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rccl";
  version = "5.3.3";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rccl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-whRXGD8oINDYhFs8+hEWKWoGNqacGlyy7xi8peA8Qsk=";
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
    rocm-smi
    gtest
  ] ++ lib.optionals buildTests [
    chrpath
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_TESTS=ON"
  ];

  # Replace the manually set parallel jobs to NIX_BUILD_CORES
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "8 P" "$NIX_BUILD_CORES P" \
      --replace "8)" "$NIX_BUILD_CORES)"
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/* $test/bin
    rmdir $out/bin
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
      -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rccl/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rccl "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rccl";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != hip.version;
  };
})
