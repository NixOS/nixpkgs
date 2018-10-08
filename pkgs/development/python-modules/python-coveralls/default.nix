{ stdenv
, buildPythonPackage
, fetchPypi
, pyyaml
, requests
, coverage
, six
, pytest
, pytestpep8
, pytestcov
, httpretty
}:

buildPythonPackage rec {
  version = "2.9.1";
  pname = "python-coveralls";

  src = fetchPypi {
    inherit pname version;
    sha256 = "736dda01f64beda240e1500d5f264b969495b05fcb325c7c0eb7ebbfd1210b70";
  };

  # Relax version contraint
  patchPhase = ''
    sed -i 's/coverage==4.0.3/coverage>=4.0.3/' setup.py
  '';

  checkInputs = [ pytest pytestpep8 pytestcov httpretty ];
  propagatedBuildInputs = [ pyyaml requests coverage six ];

  checkPhase = ''
    py.test coveralls/tests.py
  '';

  # tests require pulling in seperate repository
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://github.com/z4r/python-coveralls;
    description = "Python interface to coveralls.io API";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
