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
  version = "11.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6687a532a735a2d79a13e92bdb31cb0971abe936ea0fa78bcb47faf4372b3cb";
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
    homepage = https://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  checkPhase = ''
    # ignore performance test which may fail when the system is under load
    py.test -v -k 'not TestPerformance'
  '';
}
