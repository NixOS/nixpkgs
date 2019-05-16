{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "5.6.5";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "4730084624be98f2c326da88f3852831c6aa919e11babab2c34b0299c8f5ce2a";
  };

  propagatedBuildInputs = [
    nose
    six
  ];

  # tests require text files that are not included in the pypi package
  doCheck = false;

  meta = with lib; {
    description = "PyUtilib: A collection of Python utilities";
    homepage = https://github.com/PyUtilib/pyutilib;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
