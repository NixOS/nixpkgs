{ lib, fetchPypi, buildPythonPackage, python, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "aenum";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17cd8cfed1ee4b617198c9fabbabd70ebd8f01e54ac29cd6c3a92df14bd86656";
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

  meta = with lib; {
    description = "Advanced Enumerations (compatible with Python's stdlib Enum), NamedTuples, and NamedConstants";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.bsd3;
    homepage = "https://github.com/ethanfurman/aenum";
  };
}
