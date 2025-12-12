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
}:

buildPythonPackage rec {
  pname = "iocsearcher";
  version = "2.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    tag = "v${version}";
    hash = "sha256-qykPMtdGjys6d1cdP6cM/lmtU5WR/jk9tc9g+8uc31E=";
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
