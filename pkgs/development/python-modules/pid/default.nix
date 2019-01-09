{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8bb2ceec21a4ae84be6e9d320db1f56934b30e676e31c6f098ca7218b3d67d4";
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
