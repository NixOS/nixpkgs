{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aeeefa3a03cac8a78e4f988e935b51a4689bb1f17f20d4e827807ee11135f845";
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
