{
  buildPythonPackage,
  fetchPypi,
  lib,
  hatchling,
  hatch-requirements-txt,
  domdf-python-tools,
  idna,
}:
buildPythonPackage rec {
  pname = "apeye-core";
  version = "1.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "apeye_core";
    hash = "sha256-Xecu09AMybIP6lXlS3q49e+FAOszpTaLwWKlWF4jilU=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [
    hatch-requirements-txt
  ];

  dependencies = [
    domdf-python-tools
    idna
  ];

  meta = with lib; {
    description = "Core (offline) functionality for the apeye library.";
    homepage = "https://github.com/domdfcoding/apyey-core";
    license = licenses.mit;
    maintainers = with maintainers; [ tyberius-prime ];
  };
}
