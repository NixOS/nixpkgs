{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  ifaddr,
  pytest-aio,
  pytest-asyncio,
  pytestCheckHook,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "python-izone";
  version = "1.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Swamp-Ig";
    repo = "pizone";
    tag = "v${version}";
    hash = "sha256-4A89HG1Zlw9Cx/1I+DiJzLiOMBeINWQ1eSQ856favgU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    ifaddr
  ];

  nativeCheckInputs = [
    pytest-aio
    pytest-asyncio
    pytestCheckHook
  ];

  doCheck = false; # most tests access network

  pythonImportsCheck = [ "pizone" ];

  meta = {
    description = "Python interface to the iZone airconditioner controller";
    homepage = "https://github.com/Swamp-Ig/pizone";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
