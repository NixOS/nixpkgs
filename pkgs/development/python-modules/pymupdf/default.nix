{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, python
, swig
, mupdf
, freetype
, harfbuzz
, openjpeg
, jbig2dec
, libjpeg_turbo
, gumbo
, memstreamHook
, fonttools
}:

let
  # PyMuPDF needs the C++ bindings generated
  mupdf-cxx = mupdf.override { enableOcr = true; enableCxx = true; enablePython = true; python3 = python; };
in buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.23.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "PyMuPDF";
    rev = version;
    hash = "sha256-60KT5+EGP+s7HD4UIeaf9x2QVNU9IUbC5WKEJbrIBCI=";
  };

  nativeBuildInputs = [
    pytestCheckHook
    swig
  ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg_turbo
    gumbo
  ] ++ lib.optionals (stdenv.system == "x86_64-darwin") [
    memstreamHook
  ];

  propagatedBuildInputs = [
    mupdf-cxx
  ];

  env = {
    # force using system MuPDF (must be defined in environment and empty)
    PYMUPDF_SETUP_MUPDF_BUILD = "";
    # provide MuPDF paths
    PYMUPDF_MUPDF_LIB = "${lib.getLib mupdf-cxx}/lib";
    PYMUPDF_MUPDF_INCLUDE = "${lib.getDev mupdf-cxx}/include";
  };

  # TODO: manually add mupdf rpath until upstream fixes it
  postInstall = lib.optionalString stdenv.isDarwin ''
    for lib in */*.so $out/${python.sitePackages}/*/*.so; do
      install_name_tool -add_rpath ${lib.getLib mupdf-cxx}/lib "$lib"
    done
  '';

  checkInputs = [
    fonttools
  ];

  disabledTests = [
    # fails for indeterminate reasons
    "test_color_count"
  ] ++ lib.optionals stdenv.isDarwin [
    # darwin does not support OCR right now
    "test_tesseract"
  ];

  pythonImportsCheck = [
    "fitz"
    "fitz_new"
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
