{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z9c4ig19hjk18agwljv5ib3pphicg50w9z5zsnqn97q7vnv17gm";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = https://distlib.readthedocs.io;
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

