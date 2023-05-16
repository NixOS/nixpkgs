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
<<<<<<< HEAD
  version = "1.22.5";
=======
  version = "1.21.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyMuPDF";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-XsjVEGdSKXUp0NaNRs/EzpmRSqvZm+hD8VmaGELWP+k=";
=======
    hash = "sha256-+BV0GkNcYqADa7y/X6bFM1Z71pxTONQTcU/FeyLbk+A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
