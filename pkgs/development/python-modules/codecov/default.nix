{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf30a41f65e747b159e2a749d1f9c92042d358bba0905fd94d3def3a368e592c";
  };

  checkInputs = [ unittest2 ]; # Tests only

  propagatedBuildInputs = [ requests coverage ];

  postPatch = ''
    sed -i 's/, "argparse"//' setup.py
  '';

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python report uploader for Codecov";
    homepage = "https://codecov.io/";
    license = stdenv.lib.licenses.asl20;
  };
}
