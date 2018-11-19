{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h4fxw5drrhfyslzmfpljk0qnnpbhhb20hnnndzahhbwylyw1x1n";
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
