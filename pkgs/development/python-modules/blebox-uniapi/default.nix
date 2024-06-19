{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  semver,
  deepmerge,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "refs/tags/v${version}";
    hash = "sha256-nqxbwHzx2cnojw/XX9XQoVvOCCd88tulY0m9xEHU3m4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
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
