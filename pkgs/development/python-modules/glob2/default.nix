{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "glob2";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "135bj8gm6vn45vv0phrvhyir36kfm17y7kmasxinv8lagk8dphw5";
  };

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Version of the glob module that can capture patterns and supports recursive wildcards";
    homepage = "https://github.com/miracle2k/python-glob2/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
