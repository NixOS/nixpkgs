{ lib, buildPythonPackage, fetchPypi, isPy3k
, setuptools-scm
, beancount
, pytest, sh
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "beancount_docverif";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CFBv1FZP5JO+1MPnD86ttrO42zZlvE157zqig7s4HOg=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    beancount
  ];

  nativeCheckInputs = [
    pytest
    sh
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/siriobalmelli/beancount_docverif";
    description = "Document verification plugin for Beancount";
    longDescription = ''
        Docverif is the "Document Verification" plugin for beancount, fulfilling the following functions:

        - Require that every transaction touching an account have an accompanying document on disk.
        - Explicitly declare the name of a document accompanying a transaction.
        - Explicitly declare that a transaction is expected not to have an accompanying document.
        - Look for an "implicit" PDF document matching transaction data.
        - Associate (and require) a document with any type of entry, including open entries themselves.
        - Guarantee integrity: verify that every document declared does in fact exist on disk.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
