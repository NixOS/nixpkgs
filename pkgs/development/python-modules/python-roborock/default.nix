{
  lib,
  stdenv,
  aiohttp,
  aiomqtt,
  aioresponses,
  buildPythonPackage,
  click,
  construct,
  dacite,
  fetchFromGitHub,
  fetchpatch,
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
  pyyaml,
  click-shell,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-roborock";
  version = "2.54.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Python-roborock";
    repo = "python-roborock";
    tag = "v${version}";
    hash = "sha256-UiIdRaYnqZ27ll7Tny781zrGRKs9Rp/zP2DsA6SF9mI=";
  };

  patches = [
    # https://github.com/Python-roborock/python-roborock/pull/527
    (fetchpatch {
      name = "replace async-timeout with asyncio.timeout.patch";
      url = "https://github.com/Python-roborock/python-roborock/commit/f376027f5933e163441cf1815b820056731a3632.patch";
      excludes = [ "poetry.lock" ];
      hash = "sha256-53xsQ3yxh9CilC9hNS31rDXZVFG+mMhe7ffOb4L6bUE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core==1.8.0" "poetry-core"
  '';

  pythonRelaxDeps = [ "pycryptodome" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
    click
    construct
    dacite
    paho-mqtt
    pycryptodome
    pyrate-limiter
    vacuum-map-parser-roborock
    pyyaml
    pyshark
    click-shell
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ pycryptodomex ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "roborock" ];

  meta = with lib; {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/Python-roborock/python-roborock";
    changelog = "https://github.com/Python-roborock/python-roborock/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "roborock";
  };
}
