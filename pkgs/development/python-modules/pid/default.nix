{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "077da788630394adce075c88f4a087bcdb27d98cab67eb9046ebcfeedfc1194d";
  };

  buildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = https://github.com/trbs/pid/;
    license = licenses.asl20;
  };

}
