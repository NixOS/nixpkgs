{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  prompt-toolkit,
  pycryptodome,
  pydantic,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykoplenti";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stegm";
    repo = "pykoplenti";
    tag = "v${version}";
    hash = "sha256-Mwh6QOdsvf32U09ebleEKL7vt3xz8tjiftVVxKL/lO4=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
    mainProgram = "pykoplenti";
    homepage = "https://github.com/stegm/pykoplenti/";
    changelog = "https://github.com/stegm/pykoplenti/releases/tag/${src.tag}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
