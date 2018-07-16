{ stdenv, fetchPypi, buildPythonPackage, python, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3208e4b28db3a7b232ff69b934aef2ea1bf27286d9978e1e597d46f490e4687";
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
