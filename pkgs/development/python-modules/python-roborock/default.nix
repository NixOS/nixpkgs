{
  lib,
  stdenv,
  aiohttp,
  aiomqtt,
  aioresponses,
  async-timeout,
  buildPythonPackage,
  click,
  construct,
  dacite,
  fetchFromGitHub,
  freezegun,
  paho-mqtt,
  poetry-core,
  pycryptodome,
  pycryptodomex,
  pyrate-limiter,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  vacuum-map-parser-roborock,
  pyshark,
}:

buildPythonPackage rec {
  pname = "python-roborock";
  version = "2.25.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "humbertogontijo";
    repo = "python-roborock";
    tag = "v${version}";
    hash = "sha256-RsNWhcScp81plqXg9NmRFJhF+aLA0ld0A5H6mHo60uE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core==1.8.0" "poetry-core"
  '';

  pythonRelaxDeps = [ "pycryptodome" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
    async-timeout
    click
    construct
    dacite
    paho-mqtt
    pycryptodome
    pyrate-limiter
    vacuum-map-parser-roborock
    pyshark
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ pycryptodomex ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "roborock" ];

  meta = with lib; {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/humbertogontijo/python-roborock";
    changelog = "https://github.com/humbertogontijo/python-roborock/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "roborock";
  };
}
