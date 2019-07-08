{ stdenv
, buildPythonPackage
, fetchPypi
, ruamel_base
, ruamel_ordereddict
, isPy3k
}:

buildPythonPackage rec {
  pname = "ruamel.yaml";
  version = "0.15.96";

  src = fetchPypi {
    inherit pname version;
    sha256 = "343ace5ffbab036536a3da65e4cfd31b8292388a389f6305744984581a479b2a";
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
