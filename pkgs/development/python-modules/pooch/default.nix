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
  version = "1.5.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5969b2f1defbdc405df932767e05e0b536e2771c27f1f95d7f260bc99bf13581";
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
