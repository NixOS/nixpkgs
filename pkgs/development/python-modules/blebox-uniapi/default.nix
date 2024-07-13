{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  semver,
  deepmerge,
  jmespath,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-/NXAyEv4RR12/aoSodKiexKlC83GB1YQVAii8vf6U8c=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    jmespath
    semver
  ];

  nativeCheckInputs = [
    deepmerge
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blebox_uniapi" ];

  meta = with lib; {
    changelog = "https://github.com/blebox/blebox_uniapi/blob/v${version}/HISTORY.rst";
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
