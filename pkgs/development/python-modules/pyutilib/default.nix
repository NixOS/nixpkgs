{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "5.7.2";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "0bdb5hlj6kyb9m3xnpxzasfv5psnxfj21qx6md8ym8zkcqyq1qs5";
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
