{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, libiconv
, pytestCheckHook
, python
, pythonOlder
, pyyaml
, rustPlatform
, setuptools-rust
, setuptools-scm
, typing-extensions
, typing-inspect
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.4.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lm62rVL5f+fu4KzOQMroM0Eu27l5v2dkGtRiIVPFNhg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-i5BYYiILadKEPIJOaWdG1lZNSHfNQnwmc5j0D1jg/kc=";
  };

  cargoRoot = "native";

  postPatch = ''
    # test try to format files, which isn't necessary when consuming releases
    sed -i libcst/codegen/generate.py \
      -e '/ufmt/c\        pass'
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-rust
    setuptools-scm
    rustPlatform.cargoSetupHook
  ] ++ (with rustPlatform; [ rust.cargo rust.rustc ]);

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  propagatedBuildInputs = [
    typing-extensions
    typing-inspect
    pyyaml
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  preCheck = ''
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
