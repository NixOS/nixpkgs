{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  cryptography,
  dateparser,
  fetchFromGitHub,
  marshmallow-dataclass,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  syrupy,
  tabulate,
  typeguard,
}:

buildPythonPackage rec {
  pname = "renault-api";
<<<<<<< HEAD
  version = "0.5.2";
=======
  version = "0.5.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "renault-api";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7ZvUg2Dgu9hSG1VXDT+YC6PBbylsR4d12ZR66UrPlyE=";
=======
    hash = "sha256-FH6x+hknNGgrSHaOt7RTYeuVLqb/DNy7X3065VvcFwA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    cryptography
    marshmallow-dataclass
    pyjwt
  ];

  optional-dependencies = {
    cli = [
      click
      dateparser
      tabulate
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
    typeguard
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "renault_api" ];

  meta = {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "renault_api" ];

  meta = with lib; {
    description = "Python library to interact with the Renault API";
    homepage = "https://github.com/hacf-fr/renault-api";
    changelog = "https://github.com/hacf-fr/renault-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "renault-api";
  };
}
