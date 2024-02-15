{ stdenv
, lib
, fetchFromGitHub
, python
, buildPythonPackage
, pythonRelaxDepsHook
, imagemagick
, pip
, pytestCheckHook
, pymupdf
, fire
, fonttools
, numpy
, opencv4
, tkinter
, python-docx
}:
let
  version = "0.5.7";
in
buildPythonPackage {
  pname = "pdf2docx";
  inherit version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dothinking";
    repo = "pdf2docx";
    rev = "refs/tags/v${version}";
    hash = "sha256-GDftANn+ioaNR28VfRFDuFgdKoy7D4xiy0ezvWJ3zy0=";
  };

  nativeBuildInputs = [
    pip
    pythonRelaxDepsHook
    imagemagick
  ];

  pythonRemoveDeps = [ "opencv-python" ];

  preBuild = "echo '${version}' > version.txt";

  propagatedBuildInputs = [
    tkinter
    pymupdf
    fire
    fonttools
    numpy
    opencv4
    python-docx
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    # on linux the icon file can only be xbm format
    convert $out/${python.sitePackages}/pdf2docx/gui/icon.ico \
      $out/${python.sitePackages}/pdf2docx/gui/icon.xbm
    substituteInPlace $out/${python.sitePackages}/pdf2docx/gui/App.py \
      --replace 'icon.ico' 'icon.xbm' \
      --replace 'iconbitmap(icon_path)' "iconbitmap(f'@{icon_path}')"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-v" "./test/test.py::TestConversion" ];

  # Test fails due to "RuntimeError: cannot find builtin font with name 'Arial'":
  disabledTests = [ "test_unnamed_fonts" ];

  meta = with lib; {
    description = "Convert PDF to DOCX";
    homepage = "https://github.com/dothinking/pdf2docx";
    changelog = "https://github.com/dothinking/pdf2docx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
