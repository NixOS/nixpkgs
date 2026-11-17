{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybraendstofpriser";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pybraendstofpriser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U3apX4t4c4Gb14b9KznVJdYmlGyuzjG6fzpseT1v2+U=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  # The test script requires an API key and network access.
  doCheck = false;

  pythonImportsCheck = [ "pybraendstofpriser" ];

  meta = {
    description = "Library for fetching fuel prices from Fuelprices.dk API";
    homepage = "https://github.com/MTrab/pybraendstofpriser";
    changelog = "https://github.com/MTrab/pybraendstofpriser/releases/tag/${finalAttrs.src.tag}";
    # Awaiting license clarification from upstream.
    # https://github.com/MTrab/pybraendstofpriser/issues/44
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
