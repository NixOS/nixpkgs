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
  version = "1.19.6";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    sha256 = "sha256-7z0T4n8Vhdd29qJZfxE6q9KNNrZIuYOnKFCyHFOZqwg=";
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
