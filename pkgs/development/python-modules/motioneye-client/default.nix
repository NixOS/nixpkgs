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

buildPythonPackage (finalAttrs: {
  pname = "motioneye-client";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dermotduffy";
    repo = "motioneye-client";
    rev = "v${finalAttrs.version}";
    hash = "sha256-A5NYtZc2jaezTRtT9CjBi95kPBYDkbS76/4/S2SF1T4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiohttp = "^3.8.1,!=3.8.2,!=3.8.3"' 'aiohttp = "*"'
  '';

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "motioneye_client" ];

  meta = {
    description = "Python library for motionEye";
    homepage = "https://github.com/dermotduffy/motioneye-client";
    changelog = "https://github.com/motioneye-project/motioneye-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
