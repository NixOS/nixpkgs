{ lib
, buildPythonPackage
, fetchPypi
, lml
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.6.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "608d8e80da38070d3bb970d132bc47a55dcfd63b4dc03997d93646c5b2ad185b";
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
