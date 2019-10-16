{ stdenv, fetchPypi, buildPythonPackage, python, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0644e5d19627beaaf01ca1a8349371f9de962eeb63c2b2c28045b2e674975b8c";
  };

  # For Python 3, locale has to be set to en_US.UTF-8 for
  # tests to pass
  checkInputs = if isPy3k then [ glibcLocales ] else [];

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
