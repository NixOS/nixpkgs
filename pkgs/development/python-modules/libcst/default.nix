{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  hypothesmith,
  isPy313,
  libcst,
  libiconv,
  pytestCheckHook,
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
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Instagram";
    repo = "LibCST";
    tag = "v${version}";
    hash = "sha256-f3PtOTxf8AN55OF/M8QGv+ld0s+myOcLKQLVzl+6ONI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-juw/HILGZcGoicqzPXxliMGSGno5iBnYf5/9lgnc4rQ=";
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
    (if isPy313 then pyyaml-ft else pyyaml)
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
