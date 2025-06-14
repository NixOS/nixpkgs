{
  lib,
  stdenv,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "motioneye-client";
  version = "0.3.14";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "motioneye-client";
    rev = "v${version}";
    hash = "sha256-kgFSd5RjO+OtnPeAOimPTDVEfJ47rXh2Ku5xEYStHv8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiohttp = "^3.8.1,!=3.8.2,!=3.8.3"' 'aiohttp = "*"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "motioneye_client" ];

  meta = with lib; {
    description = "Python library for motionEye";
    homepage = "https://github.com/dermotduffy/motioneye-client";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
