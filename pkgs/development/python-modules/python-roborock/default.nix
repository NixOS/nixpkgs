{
  lib,
  stdenv,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  click,
  construct,
  dacite,
  fetchFromGitHub,
  paho-mqtt,
  poetry-core,
  pycryptodome,
  pycryptodomex,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "python-roborock";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "humbertogontijo";
    repo = "python-roborock";
    rev = "refs/tags/v${version}";
    hash = "sha256-YjD/aTSUeVuMyrdC2dcKgIqeBC+8NircRFLh2+mbD+8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry-core==1.8.0" "poetry-core"
  '';

  pythonRelaxDeps = [ "pycryptodome" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    click
    construct
    dacite
    paho-mqtt
    pycryptodome
  ] ++ lib.optionals stdenv.isDarwin [ pycryptodomex ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "roborock" ];

  meta = with lib; {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/humbertogontijo/python-roborock";
    changelog = "https://github.com/humbertogontijo/python-roborock/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "roborock";
  };
}
