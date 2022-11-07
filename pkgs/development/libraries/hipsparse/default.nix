{ lib
, stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocsparse
, hip
, gfortran
, git
, fetchzip ? null
, gtest ? null
, buildTests ? false
}:

assert buildTests -> fetchzip != null;
assert buildTests -> gtest != null;

# This can also use cuSPARSE as a backend instead of rocSPARSE
let
  matrices = lib.optionalAttrs buildTests import ./deps.nix {
    inherit fetchzip;
    mirror1 = "https://sparse.tamu.edu/MM";
    mirror2 = "https://www.cise.ufl.edu/research/sparse/MM";
  };
in stdenv.mkDerivation rec {
  pname = "hipsparse";
  rocmVersion = "5.3.1";
  version = "2.3.1-${rocmVersion}";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipSPARSE";
    rev = "rocm-${rocmVersion}";
    hash = "sha256-Phcihat774ZSAe1QetE/GSZzGlnCnvS9GwsHBHCaD4c=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
    gfortran
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    rocsparse
    git
  ] ++ lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ];

  # We have to manually generate the matrices
  # CMAKE_MATRICES_DIR seems to be reset in clients/tests/CMakeLists.txt
  postPatch = ''
    substituteInPlace clients/common/utility.cpp \
      --replace "#ifdef __cpp_lib_filesystem" " #if true"
  '' + lib.optionalString buildTests ''
    mkdir -p matrices

    ln -s ${matrices.matrix-01}/*.mtx matrices
    ln -s ${matrices.matrix-02}/*.mtx matrices
    ln -s ${matrices.matrix-03}/*.mtx matrices
    ln -s ${matrices.matrix-04}/*.mtx matrices
    ln -s ${matrices.matrix-05}/*.mtx matrices
    ln -s ${matrices.matrix-06}/*.mtx matrices
    ln -s ${matrices.matrix-07}/*.mtx matrices
    ln -s ${matrices.matrix-08}/*.mtx matrices
    ln -s ${matrices.matrix-09}/*.mtx matrices
    ln -s ${matrices.matrix-10}/*.mtx matrices
    ln -s ${matrices.matrix-11}/*.mtx matrices
    ln -s ${matrices.matrix-12}/*.mtx matrices
    ln -s ${matrices.matrix-13}/*.mtx matrices
    ln -s ${matrices.matrix-14}/*.mtx matrices
    ln -s ${matrices.matrix-15}/*.mtx matrices
    ln -s ${matrices.matrix-16}/*.mtx matrices
    ln -s ${matrices.matrix-17}/*.mtx matrices
    ln -s ${matrices.matrix-18}/*.mtx matrices
    ln -s ${matrices.matrix-19}/*.mtx matrices

    # Not used by the original cmake, causes an error
    rm matrices/*_b.mtx

    echo "deps/convert.cpp -> deps/mtx2csr"
    hipcc deps/convert.cpp -O3 -o deps/mtx2csr

    for mat in $(ls -1 matrices | cut -d "." -f 1); do
      echo "mtx2csr: $mat.mtx -> $mat.bin"
      deps/mtx2csr matrices/$mat.mtx matrices/$mat.bin
      unlink matrices/$mat.mtx
    done

    substituteInPlace clients/tests/CMakeLists.txt \
      --replace "\''${PROJECT_BINARY_DIR}/matrices" "/build/source/matrices"
  '';

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/hipsparse-test $test/bin
    mv /build/source/matrices $test
    rmdir $out/bin
  '';

  meta = with lib; {
    description = "ROCm SPARSE marshalling library";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipSPARSE";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != hip.version;
  };
}
