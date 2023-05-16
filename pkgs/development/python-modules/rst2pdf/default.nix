{ lib
, buildPythonPackage
, fetchPypi
, setuptools
<<<<<<< HEAD
, setuptools-scm
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, docutils
, importlib-metadata
, jinja2
, packaging
, pygments
, pyyaml
, reportlab
, smartypants
, pillow
, pytestCheckHook
, pymupdf
, sphinx
}:

buildPythonPackage rec {
  pname = "rst2pdf";
<<<<<<< HEAD
  version = "0.101";
=======
  version = "0.100";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-AF8FssEIFHmeY2oVrAPNe85pbmgKWO52yD6ycNNzTSg=";
=======
    sha256 = "sha256-Zkw8FubT3qJ06ECkNurE26bLUKtq8xYvydVxa+PLe0I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    setuptools-scm
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    docutils
    importlib-metadata
    jinja2
    packaging
    pygments
    pyyaml
    reportlab
    smartypants
    pillow
  ];

  pythonImportsCheck = [
    "rst2pdf"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pymupdf
    sphinx
  ];

  # Test suite fails: https://github.com/rst2pdf/rst2pdf/issues/1067
  doCheck = false;

  postInstall = ''
    mkdir -p $man/share/man/man1/
    ${docutils}/bin/rst2man.py doc/rst2pdf.rst $man/share/man/man1/rst2pdf.1
  '';

  meta = with lib; {
    description = "Convert reStructured Text to PDF via ReportLab";
    homepage = "https://rst2pdf.org/";
<<<<<<< HEAD
    changelog = "https://github.com/rst2pdf/rst2pdf/blob/${version}/CHANGES.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
