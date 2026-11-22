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
}:

buildPythonPackage rec {
  pname = "motioneye-client";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "motioneye-project";
    repo = "motioneye-client";
    rev = "v${version}";
    hash = "sha256-z7a3TsO+L3ouWo+gO6QPopyLQEelE/f3B8Z4kU/7WW4=";
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

  meta = {
    description = "Python library for motionEye";
    homepage = "https://github.com/motioneye-project/motioneye-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
