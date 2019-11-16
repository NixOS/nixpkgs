{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "5.7.1";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "1m5ijc5qmv8hg4yj496ix77hbcf7ylk4sa98ym53sfsyz0mg3kxr";
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
