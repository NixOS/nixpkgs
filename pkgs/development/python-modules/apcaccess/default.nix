{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "apcaccess";
  version = "0.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flyte";
    repo = "apcaccess";
    tag = finalAttrs.version;
    hash = "sha256-XLoNRh6MgXCfRtWD9NpVZSyroW6E9nRYw6Grxa+AQkc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "setup_requires='pytest-runner'," ""
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "apcaccess" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Library offers programmatic access to the status information provided by apcupsd over its Network Information Server";
    mainProgram = "apcaccess";
    homepage = "https://github.com/flyte/apcaccess";
    changelog = "https://github.com/flyte/apcaccess/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
})
