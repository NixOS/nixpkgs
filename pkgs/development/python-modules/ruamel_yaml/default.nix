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
  version = "0.17.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "374373b4743aee9f6d9f40bea600fe020a7ac7ae36b838b4a6a93f72b584a14c";
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
