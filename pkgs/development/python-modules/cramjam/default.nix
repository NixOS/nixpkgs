{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, stdenv
, libiconv
, hypothesis
, numpy
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "refs/tags/v${version}";
    hash = "sha256-BO35s7qOW4+l968I9qn9L1m2BtgRFNYUNlA7W1sctT8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-YWXf+ZDJLq6VxI5sa9G63fCPz2377BVSTmPM0mQSu8M=";
  };

  buildAndTestSubdir = "cramjam-python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "cramjam-python/tests"
  ];

  disabledTestPaths = [
    "cramjam-python/benchmarks/test_bench.py"
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
