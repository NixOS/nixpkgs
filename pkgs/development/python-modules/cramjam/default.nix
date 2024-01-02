{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, stdenv
, libiconv
, brotli
, hypothesis
, lz4
, memory-profiler
, numpy
, py
, pytest-benchmark
, pytestCheckHook
, python-snappy
, zstd
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.6.2.post1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "refs/tags/v${version}";
    hash = "sha256-KU1JVNEQJadXNiIWTvI33N2NSq994xoKxcAGGezFjaI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-w1bEf+etLgR/YOyLmC3lFtO9fqAx8z2aul/XIKUQb5k=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeCheckInputs = [
    brotli
    hypothesis
    lz4
    memory-profiler
    numpy
    py
    pytest-benchmark
    pytestCheckHook
    python-snappy
    zstd
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  disabledTestPaths = [
    "benchmarks/test_bench.py"
  ];

  pythonImportsCheck = [
    "cramjam"
  ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
