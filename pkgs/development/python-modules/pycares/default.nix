{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a18341ea030e2cc0743acdf4aa72302bdf6b820938b36ce4bd76e43faa2276a3";
  };

  propagatedBuildInputs = [ pkgs.c-ares ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/saghul/pycares;
    description = "Interface for c-ares";
    license = licenses.mit;
  };

}
