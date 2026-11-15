{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-executable,
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
  rich,
}:

buildPythonPackage rec {
  pname = "dissect-cobaltstrike";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cobaltstrike";
    tag = "v${version}";
    hash = "sha256-j7aCTwt5VCvLs4v5np3rQDykxfh69cURtJFXnGlRahc=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    dissect-cstruct
    dissect-executable
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
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "dissect.cobaltstrike" ];

  disabledTests = [
    # Don't run tests with a beacon
    "test_c2profile_beacon_gate"
    "test_beacon_dump_guardrails"
  ];

  meta = {
    description = "Dissect module implementing a parser for Cobalt Strike related data";
    homepage = "https://github.com/fox-it/dissect.cobaltstrike";
    changelog = "https://github.com/fox-it/dissect.cobaltstrike/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
