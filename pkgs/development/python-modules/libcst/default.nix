{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  callPackage,
  cargo,
  hypothesmith,
  libcst,
  libiconv,
  pytestCheckHook,
  python,
  pythonOlder,
  pyyaml,
  pyyaml-ft,
  rustPlatform,
  rustc,
  setuptools-rust,
  setuptools-scm,
  ufmt,
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "1.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Instagram";
    repo = "LibCST";
    tag = "v${version}";
    hash = "sha256-AJm3grS+I/NXZ8ame4rmHPOxRHGO0Ofo35RtSDO2tyI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-7/Yf2yn7wjW0CDG1Ha3SsvOIytbU1bJCpR9WFAFiPEA=";
  };

  cargoRoot = "native";

  build-system = [
    setuptools-rust
    setuptools-scm
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [
    (if pythonOlder "3.13" then pyyaml else pyyaml-ft)
  ];

  nativeCheckInputs = [
    hypothesmith
    pytestCheckHook
    ufmt
  ];

  preCheck = ''
    # import from $out instead
    rm libcst/__init__.py
  '';

  disabledTests = [
    # FIXME package pyre-test
    "TypeInferenceProviderTest"
    # we'd need to run `python -m libcst.codegen.generate all` but shouldn't modify $out
    "test_codegen_clean_visitor_functions"
    "test_codegen_clean_matcher_classes"
    "test_codegen_clean_return_types"
  ];

  # circular dependency on hypothesmith and ufmt
  doCheck = false;

  passthru.tests = {
    pytest = libcst.overridePythonAttrs { doCheck = true; };
  };

  pythonImportsCheck = [ "libcst" ];

  meta = {
    description = "Concrete Syntax Tree (CST) parser and serializer library for Python";
    homepage = "https://github.com/Instagram/LibCST";
    changelog = "https://github.com/Instagram/LibCST/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
      psfl
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
