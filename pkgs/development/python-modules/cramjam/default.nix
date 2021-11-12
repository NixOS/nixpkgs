{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, stdenv
, libiconv
, brotli
, lz4
, memory_profiler
, numpy
, pytest-benchmark
, pytestCheckHook
, python-snappy
, zstd
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "v${version}";
    sha256 = "sha256-00KvbiTf8PxYWljLKTRZmPIAbb+PnBleDM4p0AzZhHw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "sha256-4y/jeEZjVUbaXtBx5l3Hrbnj3iNYX089K4xexRP+5v0=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  checkInputs = [
    brotli
    lz4
    memory_profiler
    numpy
    pytest-benchmark
    pytestCheckHook
    python-snappy
    zstd
  ];
  pytestFlagsArray = [ "--benchmark-disable" ];
  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
