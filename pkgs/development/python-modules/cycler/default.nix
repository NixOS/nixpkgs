{ lib
, buildPythonPackage
, fetchPypi
, coverage
, nose
, six
, python
}:

buildPythonPackage rec {
  pname = "cycler";
  name = "${pname}-${version}";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8";
  };

  checkInputs = [ coverage nose ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    ${python.interpreter} run_tests.py
  '';

  # Tests were not included in release.
  # https://github.com/matplotlib/cycler/issues/31
  doCheck = false;

  meta = {
    description = "Composable style cycles";
    homepage = http://github.com/matplotlib/cycler;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}