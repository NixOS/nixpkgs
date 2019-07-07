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
  version = "2.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25199318e8cc3c25dcb45cbe084cc061051336d5a9ea2a12448d3d8cb748f742";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") scandir;
  checkInputs = [ glibcLocales ] ++ lib.optional (pythonOlder "3.3") mock;

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = https://pypi.python.org/pypi/pathlib2/;
    license = with lib.licenses; [ mit ];
  };
}
