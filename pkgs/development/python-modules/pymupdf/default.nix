{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, swig
, xcbuild
, mupdf
, freetype
, harfbuzz
, openjpeg
, jbig2dec
, libjpeg_turbo
, gumbo
, memstreamHook
}:

buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.22.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
    hash = "sha256-XsjVEGdSKXUp0NaNRs/EzpmRSqvZm+hD8VmaGELWP+k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
        --replace '/usr/include/mupdf' ${mupdf.dev}/include/mupdf
  '';
  nativeBuildInputs = [
    swig
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild
  ];

  buildInputs = [
    mupdf
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg_turbo
    gumbo
  ] ++ lib.optionals (stdenv.system == "x86_64-darwin") [
    memstreamHook
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
    platforms = platforms.unix;
  };
}
