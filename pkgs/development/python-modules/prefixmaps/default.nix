{
  lib,
  fetchPypi,
  buildPythonPackage,
  curies,
  poetry-core,
  poetry-dynamic-versioning,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "prefixmaps";
  version = "0.2.6";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dCHhJE7qYQIX+hupbJrr1k6BYqkw3AYmIHzYv2Ls9Lk=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];
  propagatedBuildInputs = [
    curies
    pyyaml
  ];

  pythonImportsCheck = [ "prefixmaps" ];

  preDistPhases = [ "pystowHomePhase" ];
  pystowHomePhase = ''
    export PYSTOW_HOME="$TMPDIR/pystow-home"
  '';

  meta = {
    description = "Semantic prefix maps for CURIE and URI handling";
    homepage = "https://github.com/linkml/prefixmaps";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
