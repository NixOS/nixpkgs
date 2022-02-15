{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, fetchpatch
, pikepdf
, pillow
, stdenv
, exiftool
, ghostscript
, imagemagick
, mupdf
, netpbm
, numpy
, poppler_utils
, pytestCheckHook
, scipy
}:

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.4.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jlHFBD76lddRSBtRYHGgBvh8KkBZlhqaxD7COJFd4J8=";
  };

  patches = [
    # Disable tests broken by Pillow 9.0.0
    # https://gitlab.mister-muffin.de/josch/img2pdf/issues/130#issuecomment-586
    (fetchpatch {
      url = "https://salsa.debian.org/debian/img2pdf/-/raw/f77fefc81e7c4b235c47ae6777d222d391c59536/debian/patches/pillow9";
      sha256 = "sha256-8giZCuv5PzSbrBQqslNqiLOhgxbg3LsdBVwt+DWnvh4=";
    })
  ];

  propagatedBuildInputs = [
    pikepdf
    pillow
  ];

  # https://gitlab.mister-muffin.de/josch/img2pdf/issues/128
  doCheck = !stdenv.isAarch64;

  checkInputs = [
    exiftool
    ghostscript
    imagemagick
    mupdf
    netpbm
    numpy
    poppler_utils
    pytestCheckHook
    scipy
  ];

  preCheck = ''
    export img2pdfprog="$out/bin/img2pdf"
  '';

  disabledTests = [
    "test_tiff_rgb"
  ];

  pythonImportsCheck = [ "img2pdf" ];

  meta = with lib; {
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ veprbl dotlambda ];
  };
}
