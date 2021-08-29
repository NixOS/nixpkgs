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
}:

buildPythonPackage rec {
  pname = "internetarchive";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72094f05df39bb1463f61f928f3a7fa0dd236cab185cb8b7e8eb6c85e09acdc4";
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
