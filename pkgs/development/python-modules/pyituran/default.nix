{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyituran";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "shmuelzon";
    repo = "pyituran";
    rev = "refs/tags/${version}";
    hash = "sha256-rgPW+z70Z9wRzPbPtWUHb80vCccWJlEs18Y6llIeipo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'os.environ["VERSION"]' '"${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyituran" ];

  meta = {
    description = "Module to interact with the Ituran web service";
    homepage = "https://github.com/shmuelzon/pyituran";
    changelog = "https://github.com/shmuelzon/pyituran/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
