{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, ruamel-base
, ruamel-yaml-clib
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.18.5";
  pyproject = true;

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    hash = "sha256-YZF+OjWlacETOo93LhImlhv1oRmL6n4j8GoIQd6hqw4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ]
    ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    changelog = "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
