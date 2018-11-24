{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, gflags
, dateutil
, mox
, python
}:

buildPythonPackage rec {
  pname = "google-apputils";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "47959d0651c32102c10ad919b8a0ffe0ae85f44b8457ddcf2bdc0358fb03dc29";
  };

  preConfigure = ''
    sed -i '/ez_setup/d' setup.py
  '';

  propagatedBuildInputs = [ pytz gflags dateutil mox ];

  checkPhase = ''
    ${python.executable} setup.py google_test
  '';

  # ERROR:root:Trying to access flag test_tmpdir before flags were parsed.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Google Application Utilities for Python";
    homepage = http://code.google.com/p/google-apputils-python;
    license = licenses.asl20;
  };

}
