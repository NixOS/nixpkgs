{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, fetchpatch
, hypothesis
, passlib
, poetry-core
, pytest-logdog
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pyyaml
, transitions
, websockets
}:

buildPythonPackage rec {
  pname = "amqtt";
  version = "unstable-2022-01-11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yakifo";
    repo = pname;
    rev = "8961b8fff57007a5d9907b98bc555f0519974ce9";
    hash = "sha256-3uwz4RSoa6KRC8mlVfeIMLPH6F2kOJjQjjXCrnVX0Jo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docopt
    passlib
    pyyaml
    transitions
    websockets
  ];

  checkInputs = [
    hypothesis
    pytest-logdog
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'PyYAML = "^5.4.0"' 'PyYAML = "*"'
  '';

  disabledTestPaths = [
    # Test are not ported from hbmqtt yet
    "tests/test_cli.py"
    "tests/test_client.py"
  ];

  preCheck = ''
    # Some tests need amqtt
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [
    "amqtt"
  ];

  meta = with lib; {
    description = "Python MQTT client and broker implementation";
    homepage = "https://amqtt.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
