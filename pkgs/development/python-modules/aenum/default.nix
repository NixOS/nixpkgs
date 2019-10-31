{ stdenv, fetchPypi, buildPythonPackage, python, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b12a7be3d89b270f266f8643aaa126404e5cdc0929bd6f09548b8eaed85e2aa1";
  };

  # For Python 3, locale has to be set to en_US.UTF-8 for
  # tests to pass
  checkInputs = if isPy3k then [ glibcLocales ] else [];

  # py2 likes to reorder tests
  doCheck = isPy3k;
  checkPhase = ''
  runHook preCheck
  ${if isPy3k then "export LC_ALL=en_US.UTF-8" else ""}
  PYTHONPATH=`pwd` ${python.interpreter} aenum/test.py
  runHook postCheck
  '';


  meta = {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    maintainers = with stdenv.lib.maintainers; [ vrthra ];
    license = with stdenv.lib.licenses; [ bsd3 ];
    homepage = https://bitbucket.org/stoneleaf/aenum;
  };
}
