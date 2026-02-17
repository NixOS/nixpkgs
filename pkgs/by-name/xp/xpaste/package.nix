{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xpaste";
  version = "1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ossobv";
    repo = "xpaste";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eVnoLG+06UTOkvGhzL/XS4JBrEwbXYZ1fuNTIW7YAfE=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    xlib
  ];

  # no tests, no python module to import, no version output to check
  doCheck = false;

  meta = {
    description = "Paste text into X windows that don't work with selections";
    mainProgram = "xpaste";
    homepage = "https://github.com/ossobv/xpaste";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ gador ];
  };
})
