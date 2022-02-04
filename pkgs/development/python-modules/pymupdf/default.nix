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
}:

buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.19.2";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    sha256 = "964bbacddab9cba6cd2c8f388429fe4a97c0775b3096a13ac15724f5a1a2c58d";
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace '/usr/include/mupdf' ${mupdf.dev}/include/mupdf
  '';
  nativeBuildInputs = [ swig ];
  buildInputs = [ mupdf freetype harfbuzz openjpeg jbig2dec libjpeg_turbo gumbo ];

  doCheck = false;

  pythonImportsCheck = [ "fitz" ];

  meta = with lib; {
    description = "Python bindings for MuPDF's rendering library.";
    homepage = "https://github.com/pymupdf/PyMuPDF";
    maintainers = with maintainers; [ teto ];
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}
