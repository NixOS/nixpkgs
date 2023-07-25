{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cargo
, hypothesis
, libiconv
, pytestCheckHook
, python
, pythonOlder
, pyyaml
, rustPlatform
, rustc
, setuptools-rust
, setuptools-scm
, typing-extensions
, typing-inspect
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = "libcst";
    rev = "refs/tags/v${version}";
    hash = "sha256-FgQE8ofRXQs/zHh7AKscXu0deN3IG+Nk/h+a09Co5R8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-rPB3bAMdvjgsT3jkEDoWatW8LPwgIaFSbFPqiqANtBY=";
  };

  cargoRoot = "native";

  postPatch = ''
    # avoid infinite recursion by not formatting the release files
    substituteInPlace libcst/codegen/generate.py \
      --replace '"ufmt"' '"true"'
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-rust
    setuptools-scm
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  propagatedBuildInputs = [
    typing-extensions
    typing-inspect
    pyyaml
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
    # otherwise import libcst.native fails
    cp build/lib.*/libcst/native.* libcst/

    ${python.interpreter} -m libcst.codegen.generate visitors
    ${python.interpreter} -m libcst.codegen.generate return_types

    # Can't run all tests due to circular dependency on hypothesmith -> libcst
    rm -r {libcst/tests,libcst/codegen/tests,libcst/m*/tests}
  '';

  disabledTests = [
    # No files are generated
    "test_codemod_formatter_error_input"
  ];

  pythonImportsCheck = [
    "libcst"
  ];

  meta = with lib; {
    description = "Concrete Syntax Tree (CST) parser and serializer library for Python";
    homepage = "https://github.com/Instagram/libcst";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ ];
  };
}
