{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  base58,
  bech32,
  cashaddress,
  cbor,
  eth-hash,
  intervaltree,
  langdetect,
  lxml,
  pdfminer-six,
  phonenumbers,
  python-magic,
  readabilipy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iocsearcher";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    rev = "5f7b87761f2195eb358006f3492f0beac7ecc4b0";
    hash = "sha256-SYh0+JEZa95iBznNzXut/9Vwof6VFeSlt0/g+XmMPC0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    base58
    beautifulsoup4
    bech32
    cashaddress
    cbor
    eth-hash
    intervaltree
    langdetect
    lxml
    pdfminer-six
    phonenumbers
    python-magic
    readabilipy
  ] ++ eth-hash.optional-dependencies.pycryptodome;

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "iocsearcher" ];

  meta = with lib; {
    description = "Library and command line tool for extracting indicators of compromise (IOCs)";
    mainProgram = "iocsearcher";
    homepage = "https://github.com/malicialab/iocsearcher";
    changelog = "https://github.com/malicialab/iocsearcher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
