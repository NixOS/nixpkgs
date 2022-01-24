{ lib
, buildPythonPackage
, fetchPypi
, six
, pythonOlder
, scandir ? null
, glibcLocales
, mock ? null
}:

buildPythonPackage rec {
  pname = "pathlib2";
  version = "2.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d8bcb5555003cdf4a8d2872c538faa3a0f5d20630cb360e518ca3b981795e5f";
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
