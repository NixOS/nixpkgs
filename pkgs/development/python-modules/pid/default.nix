{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pdp8h1m4brxalcsmzzzmjj66vj98g6wigwmcdj5sf8p7insklgn";
  };

  buildInputs = [ nose ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = "https://github.com/trbs/pid/";
    license = licenses.asl20;
  };

}
