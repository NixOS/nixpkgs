{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  imagemagick,
  feh,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywal16";
  version = "3.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eylles";
    repo = "pywal16";
    tag = finalAttrs.version;
    hash = "sha256-68HbYH4wydaM1yY8kGHNIHTOZuUQRl+9o5ZPaemTlUE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    feh
    imagemagick
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3";
    mainProgram = "wal";
    homepage = "https://github.com/eylles/pywal16";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Fresheyeball ];
  };
})
