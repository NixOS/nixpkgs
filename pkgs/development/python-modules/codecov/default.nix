{ lib, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cde272454009d27355f9434f4e49f238c0273b216beda8472a65dc4957f473b";
  };

  checkInputs = [ unittest2 ]; # Tests only

  propagatedBuildInputs = [ requests coverage ];

  postPatch = ''
    sed -i 's/, "argparse"//' setup.py
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python report uploader for Codecov";
    homepage = "https://codecov.io/";
    license = licenses.asl20;
  };
}
