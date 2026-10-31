{
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pillow,
  reportlab,
  lib,
}:
buildPythonPackage rec {
  pname = "hocr-tools";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ocropus";
    repo = "hocr-tools";
    rev = "v${version}";
    hash = "sha256-13DAbvp2gJVey0P6O/yXLCkKGm8xIl4QOMfke+6EyZE=";
  };

  # hocr-tools uses a test framework that requires internet access
  doCheck = false;

  propagatedBuildInputs = [
    pillow
    lxml
    reportlab
  ];

  meta = {
    description = "Tools for manipulating and evaluating the hOCR format for representing multi-lingual OCR results by embedding them into HTML";
    homepage = "https://github.com/ocropus/hocr-tools";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
