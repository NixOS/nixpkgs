{
  lib,
  async-timeout,
  buildPythonPackage,
  click,
  click-log,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  voluptuous,
  zigpy,
}:

buildPythonPackage rec {
  pname = "bellows";
  version = "0.46.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "bellows";
    tag = version;
    hash = "sha256-8rdDD93RoIiBahColL7goZre/tV1pafScXwFItklFhc=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "bellows" ];

  meta = with lib; {
    description = "Python module to implement EZSP for EmberZNet devices";
    homepage = "https://github.com/zigpy/bellows";
    changelog = "https://github.com/zigpy/bellows/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
    mainProgram = "bellows";
  };
}
