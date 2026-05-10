{
  lib,
  base58,
  beautifulsoup4,
  bech32,
  buildPythonPackage,
  cashaddress,
  cbor,
  docx2python,
  eth-hash,
  fetchFromGitHub,
  intervaltree,
  langdetect,
  lxml,
  pdfminer-six,
  phonenumbers,
  python-magic,
  readabilipy,
  setuptools,
  solders,
}:

buildPythonPackage rec {
  pname = "iocsearcher";
  version = "2.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    tag = "v${version}";
    hash = "sha256-XoBb3V/2ZMrGV+i0abt7+/xEFqv6f0y99scaw8aav04=";
  };

  build-system = [ setuptools ];

  dependencies = [
    base58
    beautifulsoup4
    bech32
    cashaddress
    cbor
    docx2python
    eth-hash
    intervaltree
    langdetect
    lxml
    pdfminer-six
    phonenumbers
    python-magic
    readabilipy
    solders
  ]
  ++ eth-hash.optional-dependencies.pycryptodome;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iocsearcher" ];

  meta = {
    description = "Library and command line tool for extracting indicators of compromise (IOCs)";
    homepage = "https://github.com/malicialab/iocsearcher";
    changelog = "https://github.com/malicialab/iocsearcher/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "iocsearcher";
  };
}
