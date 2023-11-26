{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, flow-record
, httpx
, lark
, pycryptodome
, pyshark
, pytest-httpserver
, pytestCheckHook
, pythonOlder
, rich
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-cobaltstrike";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cobaltstrike";
    rev = "refs/tags/v${version}";
    hash = "sha256-CS50c3r7sdxp3CRS6XJ4QUmUFtmhFg6rSdKfYzJSOV4=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
    lark
  ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "dissect.cobaltstrike"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Cobalt Strike related data";
    homepage = "https://github.com/fox-it/dissect.cobaltstrike";
    changelog = "https://github.com/fox-it/dissect.cobaltstrike/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
