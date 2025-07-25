{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  flow-record,
  hatch-vcs,
  hatchling,
  httpx,
  lark,
  pycryptodome,
  pyshark,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "dissect-cobaltstrike";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cobaltstrike";
    tag = "v${version}";
    hash = "sha256-0Wi0H9jL7suF/d92Sg2LuE6M2EzbIWsEC7Jjd1eJGTw=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
    lark
  ];

  optional-dependencies = {
    c2 = [
      flow-record
      httpx
      pycryptodome
    ];
    pcap = [
      flow-record
      httpx
      pycryptodome
      pyshark
    ];
    full = [
      flow-record
      httpx
      pycryptodome
      pyshark
      rich
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-httpserver
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "dissect.cobaltstrike" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Cobalt Strike related data";
    homepage = "https://github.com/fox-it/dissect.cobaltstrike";
    changelog = "https://github.com/fox-it/dissect.cobaltstrike/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
