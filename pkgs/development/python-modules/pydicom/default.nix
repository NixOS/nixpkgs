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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-xt0aK908lLgNlpcI86OSxy96Z/PZnQh7+GXzJ0VMQGA=";
  };

  # Pydicom needs pydicom-data to run some tests. If these files aren't downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "bbb723879690bb77e077a6d57657930998e92bd5";
    hash = "sha256-dCI1temvpNWiWJYVfQZKy/YJ4ad5B0e9hEKHJnEeqzk=";
  };

in
buildPythonPackage {
  inherit pname version src;
  disabled = pythonOlder "3.6";

  format = "setuptools";

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
