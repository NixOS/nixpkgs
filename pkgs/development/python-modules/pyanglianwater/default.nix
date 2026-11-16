{
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  lib,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyanglianwater";
  version = "3.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pantherale0";
    repo = "pyanglianwater";
    tag = version;
    hash = "sha256-7s2SnWIS28NpKaoJd25d6BtbamD4/aCkNi3lEwbUEw8=";
  };

  postPatch = ''
    substituteInPlace pyanglianwater/_version.py \
      --replace-fail '__version__ = "0.0.0"' '__version__ = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    cryptography
    pyjwt
  ];

  pythonImportsCheck = [ "pyanglianwater" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # tests are out of date
  doCheck = false;

  meta = {
    changelog = "https://github.com/pantherale0/pyanglianwater/releases/tag/${src.tag}";
    description = "Python API to interact with Anglian Water";
    homepage = "https://github.com/pantherale0/pyanglianwater";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
