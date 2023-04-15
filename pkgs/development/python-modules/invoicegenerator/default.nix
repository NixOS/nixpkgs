{ lib
, babel
, buildPythonPackage
, fetchFromGitHub
, pillow
, pythonOlder
, reportlab
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "invoicegenerator";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "by-cx";
    repo = "invoicegenerator";
    rev = "refs/tags/v${version}";
    hash = "sha256-NrsDeABxaKaEF7RdPH3Kj0eyzgm087qgv0otiyGkYgQ=";
  };

  # Remove dependency: qrplatba
  postPatch = ''
    substituteInPlace setup.py \
      --replace "\"qrplatba>=0.3.3\"," ""
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    babel
    # addition build input for qrgen: qrplatba
    pillow
    reportlab
  ];

  # missing pkg "xmlunittest"
  doCheck = false;

  pythonImportsCheck = [
    "InvoiceGenerator"
  ];

  meta = with lib; {
    description = "This is library to generate a simple invoices.";
    homepage = "https://github.com/by-cx/InvoiceGenerator";
    changelog = "https://github.com/by-cx/InvoiceGenerator/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
