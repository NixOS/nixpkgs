{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, setuptools-scm
, pytestCheckHook
, packaging
, appdirs
, requests
}:

buildPythonPackage rec {
  pname = "pooch";
  version = "1.5.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "57ab0c43e9c5bd81227b08b9931435d71c118cd53339cc5925123a740f40b312";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ packaging appdirs requests ];

  preCheck = "HOME=$TMPDIR";
  checkInputs = [ pytestCheckHook ];
  # tries to touch network
  disabledTests = [
    "pooch_custom_url"
    "pooch_download"
    "pooch_logging_level"
    "pooch_update"
    "pooch_corrupted"
    "check_availability"
    "downloader"
    "test_retrieve"
    "test_stream_download"
    "test_fetch"
    "decompress"
    "extractprocessor_fails"
    "processor"
    "integration"
  ];

  meta = with lib; {
    description = "A friend to fetch your data files.";
    homepage = "https://github.com/fatiando/pooch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
