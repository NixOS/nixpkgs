{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cbor2,
  certifi,
  click,
  cryptography,
  mnemonic,
  pyaes,
  pycryptodomex,
  pyopenssl,
  pyscard,
  pytestCheckHook,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "pysatochip";
  version = "0.18.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "pysatochip";
    tag = "v${version}";
    hash = "sha256-J4VGdeC+IowqWnCP8JFWGU8yPEaYCzfVn6F025/mwKY=";
  };

  postPatch = ''
        # Make the optional 'nostr' dependency lazy in the CLI module.
        # We do not package 'nostr' (python-nostr) because it is unmaintained upstream,
        # relies on outdated 'secp256k1' bindings incompatible with modern libsecp256k1,
        # and is only needed for the single 'nostr_publish_message' command.
        substituteInPlace satochip_cli.py \
          --replace-fail "from nostr.event import Event, EventKind" "try:
        from nostr.event import Event, EventKind
    except ImportError:
        Event = EventKind = None"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cbor2
    certifi
    click
    cryptography
    mnemonic
    pyaes
    pycryptodomex
    pyopenssl
    pyscard
    websockets
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests"
  ];

  pythonImportsCheck = [ "pysatochip" ];

  meta = {
    description = "Simple python library to communicate with a Satochip hardware wallet";
    homepage = "https://github.com/Toporin/pysatochip";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
