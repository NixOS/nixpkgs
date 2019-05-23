{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "5.7.0";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "086fzgjb2mjgkfhg1hvc2gcyam2ab28mijygwica5fg4zz6rn32l";
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
