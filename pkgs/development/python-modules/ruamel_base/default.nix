{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ruamel.base";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wswxrn4givsm917mfl39rafgadimf1sldpbjdjws00g1wx36hf0";
  };

  meta = with stdenv.lib; {
    description = "Common routines for ruamel packages";
    homepage = https://bitbucket.org/ruamel/base;
    license = licenses.mit;
  };

}
