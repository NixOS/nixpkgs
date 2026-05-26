{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  pdm-backend,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "garminconnect";
  version = "0.2.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    tag = finalAttrs.version;
    hash = "sha256-EAmKrOmnJFn+vTfmAprd5onqW/uyOe/shSB1u0HVrIE=";
  };

  pythonRelaxDeps = [ "garth" ];

  build-system = [ pdm-backend ];

  dependencies = [
    garth
    requests
  ];

  # Tests require a token
  doCheck = false;

  pythonImportsCheck = [ "garminconnect" ];

  meta = {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
