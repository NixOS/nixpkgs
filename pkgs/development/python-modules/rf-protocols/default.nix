{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "rf-protocols";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "rf-protocols";
    tag = finalAttrs.version;
    hash = "sha256-g2e+iQXBaoGO1Yv5v+xpiM+beecErI58Ua5/FODg8Bo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=78.1.1,<83.0" setuptools
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rf_protocols" ];

  meta = {
    description = "Library to decode and encode radio frequency signals";
    homepage = "https://github.com/home-assistant-libs/rf-protocols";
    changelog = "https://github.com/home-assistant-libs/rf-protocols/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
