{ stdenv, buildPythonPackage, fetchPypi, mupdf, swig }:
buildPythonPackage rec {
  pname = "PyMuPDF";
  version = "1.16.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09h960ns42bbrv10bg99fad193yvg64snhw8x7d78wg3qqvnnicc";
  };

  patchPhase = ''
    substituteInPlace setup.py \
        --replace '/usr/include/mupdf' ${mupdf.dev}/include/mupdf
    '';
  nativeBuildInputs = [ swig ];
  buildInputs = [ mupdf ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for MuPDF's rendering library.";
    homepage = https://github.com/pymupdf/PyMuPDF;
    maintainers = with maintainers; [ teto ];
    license =  licenses.agpl3;
    platforms = platforms.linux;
  };
}
