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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  readabilipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iocsearcher";
<<<<<<< HEAD
  version = "2.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    tag = "v${version}";
    hash = "sha256-qykPMtdGjys6d1cdP6cM/lmtU5WR/jk9tc9g+8uc31E=";
=======
  version = "2.4.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "malicialab";
    repo = "iocsearcher";
    # https://github.com/malicialab/iocsearcher/issues/6
    rev = "be29cb4090284155b49a358e7fe2d24371b6a981";
    hash = "sha256-LMpFK1Z1KaKUCm/X9Sh+Gp9GNKrGWp7N4UjAOVkhmSU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library and command line tool for extracting indicators of compromise (IOCs)";
    homepage = "https://github.com/malicialab/iocsearcher";
    changelog = "https://github.com/malicialab/iocsearcher/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library and command line tool for extracting indicators of compromise (IOCs)";
    homepage = "https://github.com/malicialab/iocsearcher";
    changelog = "https://github.com/malicialab/iocsearcher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "iocsearcher";
  };
}
