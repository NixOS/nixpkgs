{ lib
, buildPythonPackage
, fetchPypi
, lml
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.5.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "CN/jlVO5ljWbFD3j2exD4ZbxE41HyrtzrwShaCG4TXk=";
  };

  propagatedBuildInputs = [
    lml
  ];

  # Tests depend on stuff that depends on this.
  doCheck = false;

  pythonImportsCheck = [ "pyexcel_io" ];

  meta = {
    description = "One interface to read and write the data in various excel formats, import the data into and export the data from databases";
    homepage = "http://docs.pyexcel.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jtojnar ];
  };
}
