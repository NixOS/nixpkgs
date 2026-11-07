{
  lib,
  fetchPypi,
  buildPythonPackage,
  pydantic,
  pystow,
  typing-extensions,
  uv-build,
}:

buildPythonPackage rec {
  pname = "curies";
  version = "0.15.3";
  pyproject = true;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bGE7Y8PT9IX8xCJIMJ0BGRHMHFH8DGpUowMR1NyHpqo=";
  };

  build-system = [ uv-build ];
  propagatedBuildInputs = [
    pydantic
    pystow
    typing-extensions
  ];

  pythonImportsCheck = [ "curies" ];

  preDistPhases = [ "pystowHomePhase" ];
  pystowHomePhase = ''
    export PYSTOW_HOME="$TMPDIR/pystow-home"
  '';

  meta = {
    description = "Idiomatic conversion between URIs and compact URIs";
    homepage = "https://github.com/biopragmatics/curies";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
