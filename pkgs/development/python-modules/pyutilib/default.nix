{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "5.8.0";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "fe31b4d6a96bf1032a2096e9daf5cff6a36a4b6b6ed62dd079e4e1e5e2560e99";
  };

  propagatedBuildInputs = [
    nose
    six
  ];

  # tests require text files that are not included in the pypi package
  doCheck = false;

  meta = with lib; {
    description = "PyUtilib: A collection of Python utilities";
    homepage = "https://github.com/PyUtilib/pyutilib";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
