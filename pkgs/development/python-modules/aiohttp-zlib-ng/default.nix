{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  zlib-ng,
}:

buildPythonPackage rec {
  pname = "aiohttp-zlib-ng";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiohttp-zlib-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-XA2XSX9KA/oBzOLJrhj78uoy6ufLbVTENYZL3y/+fwU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov=aiohttp_zlib_ng --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    zlib-ng
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aiohttp_zlib_ng" ];

  meta = with lib; {
    description = "Enable zlib_ng on aiohttp";
    homepage = "https://github.com/bdraco/aiohttp-zlib-ng";
    changelog = "https://github.com/bdraco/aiohttp-zlib-ng/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
