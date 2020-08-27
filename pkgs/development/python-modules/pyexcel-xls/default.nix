{ lib
, buildPythonPackage
, fetchPypi
, pyexcel-io
, xlrd
, xlwt
, nose
}:

buildPythonPackage rec {
  pname = "pyexcel-xls";
  version = "0.5.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "LTPrS9ja37jHO1zMaiONZbORTomnVTsfObk5exfL5AI=";
  };

  propagatedBuildInputs = [
    pyexcel-io
    xlrd
    xlwt
  ];

  # Tests are not included in the archive.
  # https://github.com/pyexcel/pyexcel-xls/issues/35
  doCheck = false;

  pythonImportsCheck = [ "pyexcel_xls" ];

  meta = {
    description = "A wrapper library to read, manipulate and write data in xls using xlrd and xlwt";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
