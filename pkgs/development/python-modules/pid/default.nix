{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "pid";
  version = "2.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96eb7dba326b88f5164bc1afdc986c7793e0d32d7f62366256a3903c7b0614ef";
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
