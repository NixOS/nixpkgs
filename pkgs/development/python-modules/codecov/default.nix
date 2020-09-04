{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "355fc7e0c0b8a133045f0d6089bde351c845e7b52b99fec5903b4ea3ab5f6aab";
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
