{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ed8b7c6791010d359baed66f84f061bba5bd41174bf324c31311e8737602788";
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
    homepage = https://codecov.io/;
    license = stdenv.lib.licenses.asl20;
  };
}
