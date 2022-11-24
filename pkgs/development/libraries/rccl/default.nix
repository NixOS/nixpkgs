{ lib
, stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocm-smi
, hip
, gtest
, chrpath ? null
, buildTests ? false
}:

assert buildTests -> chrpath != null;

stdenv.mkDerivation rec {
  pname = "rccl";
  rocmVersion = "5.3.1";
  version = "2.12.10-${rocmVersion}";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rccl";
    rev = "rocm-${rocmVersion}";
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

  meta = with lib; {
    description = "ROCm communication collectives library";
    homepage = "https://github.com/ROCmSoftwarePlatform/rccl";
    license = with licenses; [ bsd2 bsd3 ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != hip.version;
  };
}
