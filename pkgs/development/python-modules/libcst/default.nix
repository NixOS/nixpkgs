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
  version = "0.4.7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-YrGajxs8t8PU4XRkFlhwtxoa9pzpKPXq8ZvN/uqftlE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-V/WHZVvh8HtD8IUNk3V4e8/E2A8DebqY5i/lS1X6x3o=";
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
