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
  version = "0.15.77";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa19db7cc000c863f7f887a9d2268aafe4e04e4767befc63cab58f1de7ec1fd6";
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
