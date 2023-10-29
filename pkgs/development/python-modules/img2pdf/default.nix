{ lib
, buildPythonPackage
, isPy27
, fetchFromGitea
, substituteAll
, fetchpatch
, colord
, setuptools
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
  version = "0.5.0";
  disabled = isPy27;

  pyproject = true;

  src = fetchFromGitea {
    domain = "gitlab.mister-muffin.de";
    owner = "josch";
    repo = "img2pdf";
    rev = version;
    hash = "sha256-k0GqBTS8PvYDmjzyLCSdQB7oBakrEQYJcQykDNrzgcA=";
  };

  patches = [
    (substituteAll {
      src = ./default-icc-profile.patch;
      inherit colord;
    })
    (fetchpatch {
      # https://gitlab.mister-muffin.de/josch/img2pdf/issues/178
      url = "https://salsa.debian.org/debian/img2pdf/-/raw/4a7dbda0f473f7c5ffcaaf68ea4ad3f435e0920d/debian/patches/fix_tests.patch";
      hash = "sha256-A1zK6yINhS+dvyckZjqoSO1XJRTaf4OXFdq5ufUrBs8=";
    })

  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pikepdf
    pillow
  ];

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
    # https://gitlab.mister-muffin.de/josch/img2pdf/issues/178
    "test_miff_cmyk16"
  ];

  pythonImportsCheck = [ "img2pdf" ];

  meta = with lib; {
    changelog = "https://gitlab.mister-muffin.de/josch/img2pdf/src/tag/${src.rev}/CHANGES.rst";
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = licenses.lgpl3Plus;
    mainProgram = "img2pdf";
    maintainers = with maintainers; [ veprbl dotlambda ];
  };
}
