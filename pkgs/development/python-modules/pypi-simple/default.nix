{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  beautifulsoup4,
  mailbits,
  packaging,
  pydantic,
  requests,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypi-simple";
  version = "1.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pypi_simple";
    inherit (finalAttrs) version;
    hash = "sha256-Rm8vzQ1yOCKq46DM/aIuaP+M1/UKrmiRGUarHdHVh+E=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    beautifulsoup4
    mailbits
    packaging
    pydantic
    requests
  ];

  optional-dependencies = {
    tqdm = [
      tqdm
    ];
  };

  pythonImportsCheck = [
    "pypi_simple"
  ];

  meta = {
    description = "PyPI Simple Repository API client library";
    homepage = "https://pypi.org/project/pypi-simple";
    changelog = "https://github.com/jwodder/pypi-simple/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
})
