{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
}:

buildPythonPackage rec {
  pname = "pyutilib";
  version = "6.0.0";

  src = fetchPypi {
    pname = "PyUtilib";
    inherit version;
    sha256 = "d3c14f8ed9028a831b2bf51b8ab7776eba87e66cfc58a06b99c359aaa640f040";
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
