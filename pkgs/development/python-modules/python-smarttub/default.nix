{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  inflection,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "python-smarttub";
<<<<<<< HEAD
  version = "0.0.46";
=======
  version = "0.0.45";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdz";
    repo = "python-smarttub";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Hx5WVQWB5zk22jExFeka3fzfexBFC/ZWjM7S5WWxxXU=";
=======
    hash = "sha256-r9Ww3isCbgKSWkQPKWzLagPK8+OFeb+zr8Wydft0jJU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    inflection
    pyjwt
    python-dateutil
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "smarttub" ];

<<<<<<< HEAD
  meta = {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    changelog = "https://github.com/mdz/python-smarttub/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python API for SmartTub enabled hot tubs";
    homepage = "https://github.com/mdz/python-smarttub";
    changelog = "https://github.com/mdz/python-smarttub/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
