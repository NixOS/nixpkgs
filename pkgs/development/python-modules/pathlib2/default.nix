{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, scandir
, glibcLocales
}:

if !(pythonOlder "3.4") then null else buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce9007df617ef6b7bd8a31cd2089ed0c1fed1f7c23cf2bf1ba140b3dd563175d";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") scandir;
  checkInputs = [ glibcLocales ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = {
    description = "This module offers classes representing filesystem paths with semantics appropriate for different operating systems.";
    homepage = https://pypi.python.org/pypi/pathlib2/;
    license = with lib.licenses; [ mit ];
  };
}