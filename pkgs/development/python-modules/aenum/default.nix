{ stdenv, fetchPypi, buildPythonPackage, python, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "aenum";
  version = "2.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9eb1c8f48ae13c56d22a7227db0e4b1717131b284c6c0db6e4ccca6f5894df95";
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
