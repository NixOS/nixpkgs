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
  version = "10.5";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63a7af08676668fd51750f111affbd38c1a13c61aba15c6665b16681771c79a8";
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
