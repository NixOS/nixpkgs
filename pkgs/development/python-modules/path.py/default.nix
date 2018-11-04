{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytestrunner
, pytest
, glibcLocales
, packaging
}:

buildPythonPackage rec {
  pname = "path.py";
  version = "11.5.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6687a532a735a2d79a13e92bdb31cb0971abe936ea0fa78bcb47faf4372b3cb";
  };

  checkInputs = [ pytest pytestrunner glibcLocales packaging ];
  buildInputs = [ setuptools_scm ];

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = https://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  checkPhase = ''
    # Ignore pytest configuration
    rm pytest.ini
    py.test test_path.py
  '';
}
