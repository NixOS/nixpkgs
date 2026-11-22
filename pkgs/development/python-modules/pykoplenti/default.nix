{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  prompt-toolkit,
  pycryptodome,
  pydantic,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "pykoplenti";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stegm";
    repo = "pykoplenti";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ykTM87YP5M839x4XmpcktLtuCRMo0dQzL2TK5OXDDzk=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    pycryptodome
    pydantic
  ];

  optional-dependencies = {
    CLI = [
      click
      prompt-toolkit
    ];
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pykoplenti" ];

  meta = {
    description = "Python REST client API for Kostal Plenticore Inverters";
    homepage = "https://github.com/stegm/pykoplenti/";
    changelog = "https://github.com/stegm/pykoplenti/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pykoplenti";
  };
})
