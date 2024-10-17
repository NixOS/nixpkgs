{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  libiconv,
  hypothesis,
  numpy,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cramjam";
  version = "2.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "pyrus-cramjam";
    rev = "refs/tags/v${version}";
    hash = "sha256-1KD5/oZjfdXav1ZByQoyyiDSzbmY4VJsSJg/FtUFdDE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-Bp7EtyuLdLUfU3yvouNVE42klfqYt9QOwt+iGe521yI=";
  };

  buildAndTestSubdir = "cramjam-python";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlagsArray = [ "cramjam-python/tests" ];

  disabledTestPaths = [
    "cramjam-python/benchmarks/test_bench.py"
    # test_variants.py appears to be flaky
    #
    # https://github.com/NixOS/nixpkgs/pull/311584#issuecomment-2117656380
    "cramjam-python/tests/test_variants.py"
  ];

  pythonImportsCheck = [ "cramjam" ];

  meta = with lib; {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
