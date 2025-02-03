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
  rustPlatform,
  rustc,
  setuptools-rust,
  setuptools-scm,
  typing-extensions,
  typing-inspect,
  ufmt,
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = "libcst";
    rev = "refs/tags/v${version}";
    hash = "sha256-H0YO8ILWOyhYdosNRWQQ9wziFk0syKSG3vF2zuYkL2k=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-AcqHn3A7WCVyVnOBD96k4pxokhzgmCWOipK/DrIAQkU=";
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
    typing-extensions
    typing-inspect
    pyyaml
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
  ];

  # circular dependency on hypothesmith and ufmt
  doCheck = false;

  passthru.tests = {
    pytest = libcst.overridePythonAttrs { doCheck = true; };
  };

  pythonImportsCheck = [ "libcst" ];

  meta = {
    description = "Concrete Syntax Tree (CST) parser and serializer library for Python";
    homepage = "https://github.com/Instagram/libcst";
    changelog = "https://github.com/Instagram/LibCST/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
      psfl
    ];
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
