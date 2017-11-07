{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytestrunner
, pytest
, glibcLocales
}:

buildPythonPackage rec {
  pname = "path.py";
  version = "10.4";
  name = "path.py-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c63c75777c8a01f7b273c0065a8ea1e3ba0c9b369fa4a2601831e412b2c4881a";
  };

  checkInputs = [ pytest pytestrunner ];
  buildInputs = [setuptools_scm glibcLocales ];

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = http://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  checkPhase = ''
    py.test test_path.py
  '';
}