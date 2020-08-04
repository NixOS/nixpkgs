{ stdenv, buildPythonPackage, fetchPypi, mupdf, swig }:
buildPythonPackage rec {
  pname = "PyMuPDF";
  version = "1.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dn4kf6hcwr77pxlxirwmqk9kgpf55122xf48y1nhsmphkkk4ads";
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
    homepage = "https://github.com/pymupdf/PyMuPDF";
    maintainers = with maintainers; [ teto ];
    license =  licenses.agpl3;
    platforms = platforms.linux;
  };
}
