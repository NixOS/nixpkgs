{ stdenv, buildPythonPackage, fetchPypi, mupdf, swig }:
buildPythonPackage rec {
  pname = "PyMuPDF";
  version = "1.16.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9909b1db81952abb09a2c17cca8ffa17f4a05a864653d6e702ce86bfa70c6a23";
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
