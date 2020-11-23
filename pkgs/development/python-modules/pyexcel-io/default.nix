{ lib
, buildPythonPackage
, fetchPypi
, lml
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.6.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "00f15f4bae2947de49b3206f2600f78780008e044380f7aafe0ce52969cda4ca";
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
