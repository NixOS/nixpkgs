{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "unoserver";
  version = "3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unoconv";
    repo = "unoserver";
    tag = finalAttrs.version;
    hash = "sha256-tQ/e2L8r0LSDJkXbtd6ygleXn1Z9uhXYoaJN6PVFGZU=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  pythonImportsCheck = [
    "unoserver"
  ];

  meta = {
    description = "LibreOffice as a server for converting documents.";
    homepage = "https://github.com/unoconv/unoserver";
    changelog = "https://github.com/unoconv/unoserver/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "unoserver";
    # windows and macos support untested https://github.com/unoconv/unoserver#installation
    platforms = lib.platforms.linux;
  };
})
