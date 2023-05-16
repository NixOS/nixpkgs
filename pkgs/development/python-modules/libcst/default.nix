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
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "instagram";
<<<<<<< HEAD
    repo = "libcst";
    rev = "refs/tags/v${version}";
    hash = "sha256-FgQE8ofRXQs/zHh7AKscXu0deN3IG+Nk/h+a09Co5R8=";
=======
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ikddvKsvXMNHMfA9jUhvyiDXII0tTs/rE97IGI/azgA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
<<<<<<< HEAD
    sourceRoot = "${src.name}/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-rPB3bAMdvjgsT3jkEDoWatW8LPwgIaFSbFPqiqANtBY=";
=======
    sourceRoot = "source/${cargoRoot}";
    name = "${pname}-${version}";
    hash = "sha256-FWQGv3E5X+VEnTYD0uKN6W4USth8EQlEGbYgUAWZ5EQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoRoot = "native";

  postPatch = ''
<<<<<<< HEAD
    # avoid infinite recursion by not formatting the release files
    substituteInPlace libcst/codegen/generate.py \
      --replace '"ufmt"' '"true"'
=======
    # test try to format files, which isn't necessary when consuming releases
    sed -i libcst/codegen/generate.py \
      -e '/ufmt/c\        pass'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    # otherwise import libcst.native fails
    cp build/lib.*/libcst/native.* libcst/

    ${python.interpreter} -m libcst.codegen.generate visitors
    ${python.interpreter} -m libcst.codegen.generate return_types

=======
    ${python.interpreter} -m libcst.codegen.generate visitors
    ${python.interpreter} -m libcst.codegen.generate return_types
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
