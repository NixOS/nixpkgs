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
  version = "11.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16134e5b287aba4a4125a6722e7837cf2a149fccc5000c500ae6c71a5525488b";
  };

  checkInputs = [ pytest pytestrunner ];
  buildInputs = [setuptools_scm glibcLocales ];

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = https://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  checkPhase = ''
    py.test test_path.py
  '';
}
