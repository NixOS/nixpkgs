{ stdenv, buildPythonPackage, fetchPypi, mupdf, swig }:
buildPythonPackage rec {
  pname = "PyMuPDF";
  version = "1.16.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bidybzkjsc0kdd18xnhz97p70br8xh8whzwydp3a5m411cm00mg";
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
