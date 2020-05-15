{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, scandir
, glibcLocales
, mock
}:

buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cd9a47b597b37cc57de1c05e56fb1a1c9cc9fab04fe78c29acd090418529868";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") scandir;
  checkInputs = [ glibcLocales ] ++ lib.optional (pythonOlder "3.3") mock;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = "https://pypi.python.org/pypi/pathlib2/";
    license = with lib.licenses; [ mit ];
  };
}
