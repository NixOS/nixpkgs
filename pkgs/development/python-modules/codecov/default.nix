{ stdenv, buildPythonPackage, fetchPypi, requests, coverage, unittest2 }:

buildPythonPackage rec {
  pname = "codecov";
  version = "2.0.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "037h4dcl8xshlq3rj8409p11rpgnyqrhlhfq8j34s94nm0n1h76v";
  };

  buildInputs = [ unittest2 ]; # Tests only

  propagatedBuildInputs = [ requests coverage ];

  postPatch = ''
    sed -i 's/, "argparse"//' setup.py
  '';

  meta = {
    description = "Python report uploader for Codecov";
    homepage = https://codecov.io/;
    license = stdenv.lib.licenses.asl20;
  };
}
