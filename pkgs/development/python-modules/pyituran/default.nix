{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyituran";
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shmuelzon";
    repo = "pyituran";
    tag = version;
    hash = "sha256-+3trWl9eijrtGfgBn5m4KfIVhS8u/o8n90bs3a3K9mo=";
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
