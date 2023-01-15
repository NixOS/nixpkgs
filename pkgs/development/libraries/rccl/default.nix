{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-smi
, hip
, gtest
, chrpath
, buildTests ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rccl";
  version = "5.4.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rccl";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-y9gTGk8LyX7owb2xdtb6VlnIXu/CYHOjnNa/wrNl02g=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
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

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rccl";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
