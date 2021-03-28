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
  version = "1.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a1614cbf35499d833e07699ddfd344764f86959fd5535aa9ce1203f57a77f970";
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
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
