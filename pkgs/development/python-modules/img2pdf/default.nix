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
  version = "0.4.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c";
  };

  patches = [
    (fetchpatch {
      # https://gitlab.mister-muffin.de/josch/img2pdf/issues/148
      url = "https://gitlab.mister-muffin.de/josch/img2pdf/commit/57d7e07e6badb252c12015388b58fcb5285d3158.patch";
      hash = "sha256-H/g55spe/oVJRxO2Vh+F+ZgR6aLoRUrNeu5WnuU7k/k=";
    })
  ];

  propagatedBuildInputs = [
    pikepdf
    pillow
  ];

  # https://gitlab.mister-muffin.de/josch/img2pdf/issues/128
  doCheck = !stdenv.isAarch64;

  nativeCheckInputs = [
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
