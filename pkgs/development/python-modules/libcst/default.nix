{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = "libcst";
    rev = "refs/tags/v${version}";
    hash = "sha256-kFs7edBWz0GRbgbLDmtpUVi5R+6mYXsJSvceOoPW9ck=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-fhaHiz64NH6S61fSXj4gNxxcuB+ECxWSSmG5StiFr1k=";
  };

  cargoRoot = "native";

  patches = [
    # https://github.com/Instagram/LibCST/pull/1042
    (fetchpatch {
      name = "remove-distutils.patch";
      url = "https://github.com/Instagram/LibCST/commit/a6834aa0e6eb78e41549fd1087d7ba60ca4dd237.patch";
      hash = "sha256-lyIXJhm4UMwdCOso6McDslIvtK7Ar8sF5Zy7qo1nicQ=";
    })
  ];

  postPatch = ''
    # avoid infinite recursion by not formatting the release files
    substituteInPlace libcst/codegen/generate.py \
      --replace '"ufmt"' '"true"'
  '';

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
    changelog = "https://github.com/Instagram/LibCST/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ ];
  };
}
