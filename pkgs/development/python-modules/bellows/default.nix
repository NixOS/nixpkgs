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

buildPythonPackage rec {
  pname = "bellows";
  version = "0.49.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    tag = version;
    hash = "sha256-haWej3ZcUPd9Rpqf2PH8r0useylnLDaPiSctrwLz71Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
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
    changelog = "https://github.com/zigpy/bellows/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    mainProgram = "bellows";
  };
}
