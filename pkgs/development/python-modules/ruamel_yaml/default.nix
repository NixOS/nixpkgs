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
  version = "0.15.76";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dc2a9869f45ace93bb8ecc83a308498ecf9aabd4e54561280c33d29f1f3546d";
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
