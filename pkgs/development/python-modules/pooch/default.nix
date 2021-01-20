{ lib, stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, pytestCheckHook
, packaging
, appdirs
, requests
}:

buildPythonPackage rec {
  pname = "pooch";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "30d448e825904e2d763bbbe418831a788813c32f636b21c8d60ee5f474532898";
  };

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
