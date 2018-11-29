{ stdenv
, buildPythonPackage
, fetchPypi
, ruamel_base
, typing
, ruamel_ordereddict
, isPy3k
}:

buildPythonPackage rec {
  pname = "ruamel.yaml";
  version = "0.15.80";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f203351575dba0829c7b1e5d376d08cf5f58e4a2b844e8ce552b3e41cd414e6";
  };

  # Tests cannot load the module to test
  doCheck = false;

  propagatedBuildInputs = [ ruamel_base typing ]
    ++ stdenv.lib.optional (!isPy3k) ruamel_ordereddict;

  meta = with stdenv.lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = https://bitbucket.org/ruamel/yaml;
    license = licenses.mit;
  };

}
