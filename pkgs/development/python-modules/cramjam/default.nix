{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, rustPlatform
, libiconv
, pytestCheckHook
, brotli
, lz4
, memory_profiler
, numpy
, pytest-benchmark
, python-snappy
, zstd
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "577955f1510d99df0e4d61379c3f05568f594f91e12bc6a7e147d0abfa643a3b";
  };

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  checkInputs = [
    pytestCheckHook
    brotli
    lz4
    memory_profiler
    numpy
    pytest-benchmark
    python-snappy
    zstd
  ];
  pytestFlagsArray = [ "--benchmark-disable" ];
  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://crates.io/crates/cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
