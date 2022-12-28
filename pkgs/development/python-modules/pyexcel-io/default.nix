{ lib
, buildPythonPackage
, fetchPypi
, lml
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.6.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9ghL8a+l+/TGHPffRDcPpROCGvGIsC4+GbXvtm2Klp8=";
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
