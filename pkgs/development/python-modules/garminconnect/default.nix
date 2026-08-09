{
  lib,
  buildPythonPackage,
  curl-cffi,
  fetchFromGitHub,
  garth,
  pdm-backend,
  requests,
  ua-generator,
}:

buildPythonPackage (finalAttrs: {
  pname = "garminconnect";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    tag = finalAttrs.version;
    hash = "sha256-wXZKnqJwRTuekjUV1UCA02dMGgxs/NHB70b7Fx0o75A=";
  };

  pythonRelaxDeps = [ "garth" ];

  build-system = [ pdm-backend ];

  dependencies = [
    curl-cffi
    garth
    requests
    ua-generator
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
