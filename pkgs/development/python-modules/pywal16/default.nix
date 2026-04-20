{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  imagemagick,
  feh,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  withColorthief ? false,
  withColorz ? false,
  withFastColorthief ? false,
  withHaishoku ? false,
  withModernColorthief ? false,
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

  dependencies =
    lib.optionals withColorthief optional-dependencies.colorthief
    ++ lib.optionals withColorz optional-dependencies.colorz
    ++ lib.optionals withFastColorthief optional-dependencies.fast-colorthief
    ++ lib.optionals withHaishoku optional-dependencies.haishoku
    ++ lib.optionals withModernColorthief optional-dependencies.modern_colorthief;

  nativeCheckInputs = [
    feh
    imagemagick
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    installManPage data/man/man1/wal.1
  '';

  meta = {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3";
    mainProgram = "wal";
    homepage = "https://github.com/eylles/pywal16";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Fresheyeball ];
  };
})
