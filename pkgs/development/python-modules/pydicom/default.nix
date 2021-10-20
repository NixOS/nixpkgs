{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest-runner
, pytestCheckHook
, numpy
, pillow
}:

let
  pname = "pydicom";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-iExy+mUs1uqs/u9N6btlqyP6/TvoPVsuOuzs56zZAS8=";
  };

  # Pydicom needs pydicom-data to run some tests. If these files are downloaded
  # before the package creation, it'll try to download during the checkPhase.
  test_data = fetchFromGitHub {
    owner = "${pname}";
    repo = "${pname}-data";
    rev = "bbb723879690bb77e077a6d57657930998e92bd5";
    sha256 = "sha256-dCI1temvpNWiWJYVfQZKy/YJ4ad5B0e9hEKHJnEeqzk=";
  };

in
buildPythonPackage {
  inherit pname version src;
  disabled = isPy27;

  propagatedBuildInputs = [ numpy pillow ];

  checkInputs = [ pytest-runner pytestCheckHook ];

  # Setting $HOME to prevent pytest to try to create a folder inside
  # /homeless-shelter which is read-only.
  # Linking pydicom-data dicom files to $HOME/.pydicom/data
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  # This test try to remove a dicom inside $HOME/.pydicom/data/ and download it again.
  disabledTests = [
    "test_fetch_data_files"
  ] ++ lib.optionals stdenv.isAarch64 [
    # https://github.com/pydicom/pydicom/issues/1386
    "test_array"
  ] ++ lib.optionals stdenv.isDarwin [
    # flaky, hard to reproduce failure outside hydra
    "test_time_check"
  ];

  meta = with lib; {
    homepage = "https://pydicom.github.io";
    description = "Pure-Python package for working with DICOM files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
