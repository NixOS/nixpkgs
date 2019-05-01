{ stdenv
, buildPythonPackage
, fetchPypi
, ruamel_base
, ruamel_ordereddict
, isPy3k
}:

buildPythonPackage rec {
  pname = "ruamel.yaml";
  version = "0.15.92";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6d05e38a141922eca7902135e7a40b605763d6da8ec6624517370631ce9fb6d";
  };

  # Tests cannot load the module to test
  doCheck = false;

  propagatedBuildInputs = [ ruamel_base ]
    ++ stdenv.lib.optional (!isPy3k) ruamel_ordereddict;

  meta = with stdenv.lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = https://bitbucket.org/ruamel/yaml;
    license = licenses.mit;
  };

}
