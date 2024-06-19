{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  numpy,
  pillow,
}:

buildPythonPackage rec {
  pname = "minexr";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cheind";
    repo = "py-minexr";
    rev = "v${version}";
    hash = "sha256-Om67ttAHxu7C3IwPB+JHYi78E9qBi1E6layMVg4+S3M=";
  };

  propagatedBuildInputs = [ numpy ];

  pythonImportsCheck = [ "minexr" ];
  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  meta = with lib; {
    description = "Minimal, standalone OpenEXR reader for single-part, uncompressed scan line files.";
    homepage = "https://github.com/cheind/py-minexr";
    license = licenses.mit;
    maintainers = with maintainers; [ lucasew ];
  };
}
