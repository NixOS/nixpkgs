{
  lib,
  buildPythonPackage,
  click,
  click-log,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "bellows";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    tag = finalAttrs.version;
    hash = "sha256-UxvVV0zcBr21l5rgekRHqzNUP+4eg8BGp03czuULYQk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    click
    click-log
    voluptuous
    zigpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "bellows" ];

  meta = {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    mainProgram = "bellows";
  };
})
