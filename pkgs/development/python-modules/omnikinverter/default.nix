{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  uv-build,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "omnikinverter";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-omnikinverter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kx/9WnSJR7GuZiOKYq/4L0Jb1Mg1E47zlJuURNgvY9M=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.12.13,<0.13' uv_build
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "omnikinverter" ];

  meta = {
    description = "Python module for the Omnik Inverter";
    homepage = "https://github.com/klaasnicolaas/python-omnikinverter";
    changelog = "https://github.com/klaasnicolaas/python-omnikinverter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
