{ lib
, buildPythonPackage
, fetchPypi
, ruamel-base
, ruamel-ordereddict
, ruamel-yaml-clib ? null
, isPy27
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.16.13";

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    sha256 = "0hm9yg785f46bkrgqknd6fdvmkby9dpzjnm0b63qf0i748acaj5v";
  };

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ]
    ++ lib.optional isPy27 ruamel-ordereddict
    ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  # causes namespace clash on py27
  dontUsePythonImportsCheck = isPy27;
  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
