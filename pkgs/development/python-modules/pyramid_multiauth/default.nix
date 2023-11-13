{ lib
, buildPythonPackage
, fetchPypi
, pyramid
}:

buildPythonPackage rec {
  pname = "pyramid_multiauth";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d8785558e1d0bbe0d0da43e296efc0fbe0de5071d1f9b1091e891f0e4ec9682";
  };

  propagatedBuildInputs = [ pyramid ];

  meta = with lib; {
    description = "Authentication policy for Pyramid that proxies to a stack of other authentication policies";
    homepage = "https://github.com/mozilla-services/pyramid_multiauth";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
  };
}
