{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "ptvsd";
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3b05c06018fdbce5943c50fb0baac695b5c11326f9e21a5266c854306bda28ab";
  };

  # no tests in the wheel or the zip
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/Microsoft/ptvsd/";
    description = "An implementation of the Debug Adapter Protocol for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
  };
}
