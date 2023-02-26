{ buildPythonPackage
, fetchFromGitHub
, lib
, pytestCheckHook
, setuptools-scm
, pdfminer-six
}:

buildPythonPackage rec {
  pname = "pdfannots";
  version = "0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "0xabu";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VG8pECjDHxAA5+pGRgb6dmyPMoRxZm91Yay3bq4FlBM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pdfminer-six
  ];

  # TODO: Is this not needed?
  #checkInputs = [
  #  pytestCheckHook
  #];

  pyttestFlagsArray = [
    "tests.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Extracts and formats text annotations from PDFs";
    homepage = "https://github.com/9xabu/pdfnotes";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ qbit ];
  };
}
