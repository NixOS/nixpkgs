{ lib
, buildPythonPackage
, fetchPypi
, mupdf
, swig
, freetype
, harfbuzz
, openjpeg
, jbig2dec
, libjpeg_turbo
, gumbo
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.21.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    hash = "sha256-+BV0GkNcYqADa7y/X6bFM1Z71pxTONQTcU/FeyLbk+A=";
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace '/usr/include/mupdf' ${mupdf.dev}/include/mupdf
  '';
  nativeBuildInputs = [
    swig
  ];

  buildInputs = [
    mupdf
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg_turbo
    gumbo
  ];

  doCheck = false;

  pythonImportsCheck = [
    "fitz"
  ];

  meta = with lib; {
    description = "Python bindings for MuPDF's rendering library";
    homepage = "https://github.com/pymupdf/PyMuPDF";
    changelog = "https://github.com/pymupdf/PyMuPDF/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
  };
}
