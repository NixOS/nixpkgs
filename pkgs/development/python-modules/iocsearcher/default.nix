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
  pythonOlder,
  readabilipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iocsearcher";
  version = "2.4.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    # https://github.com/malicialab/iocsearcher/issues/6
    rev = "be29cb4090284155b49a358e7fe2d24371b6a981";
    hash = "sha256-LMpFK1Z1KaKUCm/X9Sh+Gp9GNKrGWp7N4UjAOVkhmSU=";
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

  meta = with lib; {
    description = "Library and command line tool for extracting indicators of compromise (IOCs)";
    homepage = "https://github.com/malicialab/iocsearcher";
    changelog = "https://github.com/malicialab/iocsearcher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "iocsearcher";
  };
}
