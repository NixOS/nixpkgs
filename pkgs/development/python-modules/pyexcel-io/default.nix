{ lib
, buildPythonPackage
, fetchPypi
, lml
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyexcel-io";
  version = "0.6.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fb7a201eb3e5763bb8f9d6e096ceed9e5f1baecd784c9fadbe0fb3d59174c0e";
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
