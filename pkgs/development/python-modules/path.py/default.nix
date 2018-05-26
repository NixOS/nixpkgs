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
  version = "11.0.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e7eb9d0ca4110d9b4d7c9baa0696d8c94f837d622409cefc5ec9e7c3d02ea11f";
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
