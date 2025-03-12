{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  replaceVars,
  fetchpatch,
  colord,
  setuptools,
  pikepdf,
  pillow,
  stdenv,
  exiftool,
  ghostscript,
  imagemagick,
  mupdf-headless,
  netpbm,
  numpy,
  poppler-utils,
  pytestCheckHook,
  runCommand,
  scipy,
}:

buildPythonPackage rec {
  pname = "img2pdf";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "gitlab.mister-muffin.de";
    owner = "josch";
    repo = "img2pdf";
    tag = version;
    hash = "sha256-/nxXgGsnj5ktxUYt9X8/9tJzXgoU8idTjVgLh+8jol8=";
  };

  patches = [
    (replaceVars ./default-icc-profile.patch {
      srgbProfile =
        if stdenv.hostPlatform.isDarwin then
          "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
        else
          # break runtime dependency chain all of colord dependencies
          runCommand "sRGC.icc" { } ''
            cp ${colord}/share/color/icc/colord/sRGB.icc $out
          '';
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    pikepdf
    pillow
  ];

  # FIXME: Only add "sRGB Profile.icc" to __impureHostDeps once
  # https://github.com/NixOS/nix/issues/9301 is fixed.
  __impureHostDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    "/System/Library/ColorSync/Profiles"
  ];

  nativeCheckInputs = [
    exiftool
    ghostscript
    imagemagick
    mupdf-headless
    netpbm
    numpy
    poppler-utils
    pytestCheckHook
    scipy
  ];

  preCheck = ''
    export img2pdfprog="$out/bin/img2pdf"
  '';

  disabledTests = [
    # https://gitlab.mister-muffin.de/josch/img2pdf/issues/178
    "test_jpg_cmyk"
    "test_miff_cmyk8"
    "test_tiff_cmyk8"
  ];

  pythonImportsCheck = [ "img2pdf" ];

  meta = {
    changelog = "https://gitlab.mister-muffin.de/josch/img2pdf/src/tag/${src.tag}/CHANGES.rst";
    description = "Convert images to PDF via direct JPEG inclusion";
    homepage = "https://gitlab.mister-muffin.de/josch/img2pdf";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "img2pdf";
    maintainers = with lib.maintainers; [
      veprbl
      dotlambda
    ];
  };
}
