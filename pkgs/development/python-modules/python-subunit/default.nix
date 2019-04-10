{ lib, buildPythonPackage, fetchPypi, extras, testtools }:

buildPythonPackage rec {
  pname = "python-subunit";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fsw8rsn1s3nklx06mayrg5rn2zbky6wwjc5z07s7rf1wjzfs1wn";
  };

  # tests require internet
  doCheck = false;

  propagatedBuildInputs = [ extras testtools ];

  meta = with lib; {
    homepage = http://launchpad.net/subunit;
    description = "Python implementation of subunit test streaming protocol";
    license = licenses.asl20;
  };
}
