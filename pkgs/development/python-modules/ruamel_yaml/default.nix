{ stdenv
, buildPythonPackage
, fetchPypi
, ruamel_base
, ruamel_ordereddict
, isPy3k
}:

buildPythonPackage rec {
  pname = "ruamel.yaml";
  version = "0.15.86";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d98b3d421eebf7e10311ab12f41c5b0353e7cae1cc78f51312e24f569d593de0";
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
