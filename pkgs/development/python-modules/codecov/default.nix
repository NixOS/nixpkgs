{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0be9cd6358cc6a3c01a1586134b0fb524dfa65ccbec3a40e9f28d5f976676ba2";
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
