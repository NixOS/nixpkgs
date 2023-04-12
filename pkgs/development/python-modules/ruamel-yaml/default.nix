{ lib
, buildPythonPackage
, fetchPypi
, ruamel-base
, ruamel-yaml-clib
, isPyPy
}:

buildPythonPackage rec {
  pname = "ruamel-yaml";
  version = "0.17.21";

  src = fetchPypi {
    pname = "ruamel.yaml";
    inherit version;
    hash = "sha256-i3zml6LyEnUqNcGsQURx3BbEJMlXO+SSa1b/P10jt68=";
  };

  # Tests use relative paths
  doCheck = false;

  propagatedBuildInputs = [ ruamel-base ]
    ++ lib.optional (!isPyPy) ruamel-yaml-clib;

  pythonImportsCheck = [ "ruamel.yaml" ];

  meta = with lib; {
    description = "YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
    homepage = "https://sourceforge.net/projects/ruamel-yaml/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
