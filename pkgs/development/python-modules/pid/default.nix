{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "daa52ff1aa4f3e21cee0df5d8862be5db96dde6e5abf7613964a626a78eca5f8";
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
