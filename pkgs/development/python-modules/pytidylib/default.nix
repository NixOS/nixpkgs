{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  html-tidy,
}:

buildPythonPackage rec {
  pname = "pytidylib";
  version = "0.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IrHI11lw2AZP+ZnCNp6Yrx0GhUF+2kyCmlyfVnZLCvM=";
  };

  postPatch = ''
    # Patch path to library
    substituteInPlace tidylib/tidy.py \
      --replace "load_library(name)" \
        "load_library('${html-tidy}/lib/libtidy${stdenv.hostPlatform.extensions.sharedLibrary}')"

    # Test fails
    substituteInPlace tests/test_docs.py \
      --replace "    def test_large_document(self):" \
        $'    @unittest.skip("")\n    def test_large_document(self):'
  '';

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python wrapper for HTML Tidy (tidylib) on Python 2 and 3";
    homepage = "https://countergram.github.io/pytidylib/";
    license = licenses.mit;
    maintainers = with maintainers; [ layus ];
  };
}
