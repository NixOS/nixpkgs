{ stdenv
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
  version = "1.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k2vinlhkzl7lzhvbz20x3a2r2zqqila0yxg3a3fax2r6qxbxxzi";
  };

  requiredPythonModules = [ packaging appdirs requests ];

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    "pooch_custom_url"
    "pooch_download"
    "pooch_logging_level"
    "pooch_update"
    "pooch_corrupted"
    "check_availability"
    "downloader"
    "test_fetch"
    "decompress"
    "extractprocessor_fails"
    "processor"
    "integration"
  ];

  meta = with stdenv.lib; {
    description = "A friend to fetch your data files.";
    homepage = "https://github.com/fatiando/pooch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };

}
