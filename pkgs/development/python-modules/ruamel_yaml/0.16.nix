{ lib
, buildPythonPackage
, fetchPypi
, ruamel_base
, ruamel_ordereddict ? null
, ruamel_yaml_clib ? null
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel.yaml";
  version = "0.16.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hm9yg785f46bkrgqknd6fdvmkby9dpzjnm0b63qf0i748acaj5v";
  };

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel_base ]
    ++ lib.optional (!isPy3k) ruamel_ordereddict
    ++ lib.optional (!isPyPy) ruamel_yaml_clib;

  # causes namespace clash on py27
  dontUsePythonImportsCheck = !isPy3k;
  pythonImportsCheck = [
    "ruamel.yaml"
    "ruamel.base"
  ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    license = licenses.mit;
  };

}
