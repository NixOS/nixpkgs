{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "1.18.16";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    sha256 = "b21e39098fbbe0fdf269fdb2d1dd25a3847bbf22785ee8903d3a5637c2d0b9d7";
  };

  patchFlags = [ "--binary" "--ignore-whitespace" ];
  patches = [
    # Add NIX environment support.
    # Should be removed next pyMuPDF release.
    (fetchpatch {
      url = "https://github.com/pymupdf/PyMuPDF/commit/d9b2d42019e5705a1c6621ea0cdfa26da1ce9ad5.patch";
      sha256 = "fc3f6ad88c8f3933ed9ab9d4db9ebec8bc30ed5113f6ca9d72080b56dfa52ad6";
    })
  ];

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
