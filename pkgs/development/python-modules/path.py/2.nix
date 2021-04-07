{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
, glibcLocales
, packaging
, isPy27
, backports_os
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "path.py";
  version = "11.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de7cd643affbc23e56533a6e8d551ecdee4983501a08c24e4e71565202d8cdaa";
  };

  checkInputs = [ pytest pytest-flake8 glibcLocales packaging ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional isPy27 backports_os
  ;

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = "https://github.com/jaraco/path.py";
    license = lib.licenses.mit;
  };

  checkPhase = ''
    # ignore performance test which may fail when the system is under load
    py.test -v -k 'not TestPerformance'
  '';
}
