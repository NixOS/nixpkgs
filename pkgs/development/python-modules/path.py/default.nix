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
  version = "10.3.1";
  name = "path.py-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "412706be1cd8ab723c77829f9aa0c4d4b7c7b26c7b1be0275a6841c3cb1001e0";
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