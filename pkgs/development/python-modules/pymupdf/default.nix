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
  version = "1.20.1";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    sha256 = "sha256-MFwaZLj7L9Rl4nzIvcvw9kIk8Oxtd2Pj9fLKZ4MTZkk=";
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
