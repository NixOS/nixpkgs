{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d30ad6084501224b1ba699cbf018a340bb9553eb2701301c14133995fdd84f33";
  };

  checkInputs = [ unittest2 ]; # Tests only

  requiredPythonModules = [ requests coverage ];

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
