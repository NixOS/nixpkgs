{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, pillow
, setuptools
}:

let
  pname = "pydicom";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-PF4iA/FPxPYD8OfgWqKRndwi2vURuzh6tlEwduxs/3E=";
  };

  # Pydicom needs pydicom-data to run some tests. If these files aren't downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "cbb9b2148bccf0f550e3758c07aca3d0e328e768";
    hash = "sha256-nF/j7pfcEpWHjjsqqTtIkW8hCEbuQ3J4IxpRk0qc1CQ=";
  };

in
buildPythonPackage {
  inherit pname version src;
  disabled = pythonOlder "3.6";

  format = "setuptools";

  patches = [
    # backport of https://github.com/pydicom/pydicom/commit/2513a20cc41743a42bdb86f4cbb4873899b7823c
    ./pillow-10.1.0-compat.patch
  ];

  propagatedBuildInputs = [
    numpy
    pillow
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Setting $HOME to prevent pytest to try to create a folder inside
  # /homeless-shelter which is read-only.
  # Linking pydicom-data dicom files to $HOME/.pydicom/data
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  disabledTests = [
    # tries to remove a dicom inside $HOME/.pydicom/data/ and download it again
    "test_fetch_data_files"
  ] ++ lib.optionals stdenv.isAarch64 [
    # https://github.com/pydicom/pydicom/issues/1386
    "test_array"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky, hard to reproduce failure outside hydra
    "test_time_check"
  ];

  pythonImportsCheck = [
    "pydicom"
  ];

  meta = with lib; {
    description = "Python package for working with DICOM files";
    homepage = "https://pydicom.github.io";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
