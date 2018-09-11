{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, pythonOlder
, scandir
, glibcLocales
, mock
, nose
}:

if !(pythonOlder "3.4") then null else buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eb170f8d0d61825e09a95b38be068299ddeda82f35e96c3301a8a5e7604cb83";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") scandir;
  checkInputs = [ glibcLocales ] ++ lib.optional (pythonOlder "3.3") mock;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  checkPhase = ''
    ${python.interpreter} tests/test_pathlib2.py
  '';

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = https://pypi.python.org/pypi/pathlib2/;
    license = with lib.licenses; [ mit ];
  };
}
