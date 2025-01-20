{
  lib,
  buildPythonPackage,
  fetchPypi,
  lml,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.6.7";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LDPY31BeIaE77Vhaxqt9MOyCap8Va3WDlK9dIjWb3bk=";
  };

  propagatedBuildInputs = [ lml ];

  # Tests depend on stuff that depends on this.
  doCheck = false;

  pythonImportsCheck = [ "pyexcel_io" ];

  meta = {
    description = "One interface to read and write the data in various excel formats, import the data into and export the data from databases";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
