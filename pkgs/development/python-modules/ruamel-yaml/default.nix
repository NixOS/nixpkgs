{ lib
, buildPythonPackage
, fetchPypi
, ruamel-base
, ruamel-yaml-clib
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.17.32";

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    hash = "sha256-7JOQY3YZFOFFQpcqXLptM8I7CFmrY0L2HPBwz8YA78I=";
  };

  propagatedBuildInputs = [
    ruamel-base
  ] ++ lib.optional (!isPyPy) [
    ruamel-yaml-clib
  ];

  pythonImportsCheck = [
    "ruamel.yaml"
  ];

  # Tests use relative paths
  doCheck = false;

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://yaml.readthedocs.io";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/${version}/tree/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
