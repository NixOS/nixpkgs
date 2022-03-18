{ buildPythonPackage
, fetchPypi
, pytest
, six
, tqdm
, pyyaml
, docopt
, requests
, jsonpatch
, args
, schema
, responses
, backports_csv
, isPy3k
, lib
, glibcLocales
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fRcqsT8p/tqXUpU2/9lAEF1IT8Cy5KK0+jKaeVwZshI=";
  };

  propagatedBuildInputs = [
    six
    tqdm
    pyyaml
    docopt
    requests
    jsonpatch
    args
    schema
    setuptools
    urllib3
  ] ++ lib.optionals (!isPy3k) [ backports_csv ];

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
