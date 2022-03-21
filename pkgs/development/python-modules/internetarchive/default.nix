{ buildPythonPackage
, fetchPypi
, pytest
, tqdm
, pyyaml
, docopt
, requests
, jsonpatch
, args
, schema
, responses
, lib
, glibcLocales
, setuptools
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "3.0.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fRcqsT8p/tqXUpU2/9lAEF1IT8Cy5KK0+jKaeVwZshI=";
  };

  propagatedBuildInputs = [
    tqdm
    pyyaml
    docopt
    requests
    jsonpatch
    args
    schema
    setuptools
    urllib3
  ];

  checkInputs = [ pytest responses glibcLocales ];

  # tests depend on network
  doCheck = false;

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest tests
  '';

  pythonImportsCheck = [ "internetarchive" ];

  meta = with lib; {
    description = "A Python and Command-Line Interface to Archive.org";
    homepage = "https://github.com/jjjake/internetarchive";
    changelog = "https://github.com/jjjake/internetarchive/raw/v${version}/HISTORY.rst";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.marsam ];
  };
}
