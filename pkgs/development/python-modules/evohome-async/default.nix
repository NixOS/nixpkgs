{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  aiozoneinfo,
  asyncclick,
  buildPythonPackage,
  debugpy,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytest-freezer,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  syrupy,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "evohome-async";
<<<<<<< HEAD
  version = "1.0.6";
=======
  version = "1.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "zxdavb";
    repo = "evohome-async";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-8oeW6NWqYcZF+s2kRfeoVAp8JBbuDn+NQ0RU6nxVTAc=";
=======
    hash = "sha256-4eV050Yikr+5ZIj1v11cPQQ1pAlQYckbZXVFHHfYmpA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiozoneinfo
    voluptuous
  ];

  optional-dependencies = {
    cli = [
      aiofiles
      asyncclick
      debugpy
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-freezer
    pytestCheckHook
    pyyaml
    syrupy
  ]
  ++ optional-dependencies.cli;

  pythonImportsCheck = [ "evohomeasync2" ];

<<<<<<< HEAD
  meta = {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    changelog = "https://github.com/zxdavb/evohome-async/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python client for connecting to Honeywell's TCC RESTful API";
    homepage = "https://github.com/zxdavb/evohome-async";
    changelog = "https://github.com/zxdavb/evohome-async/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "evo-client";
  };
}
