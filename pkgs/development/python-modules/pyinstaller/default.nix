{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # native dependencies
  zlib,

  # dependencies
  altgraph,
  macholib,
  packaging,
  pyinstaller-hooks-contrib,

  # tests
  binutils,
  glibc,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyinstaller";
  version = "6.22.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ibZaOtB9ndWDIlPje8RfMYctENf51cn9D91giKg4Kd0=";
  };

  build-system = [ hatchling ];

  buildInputs = [ zlib.dev ];

  dependencies = [
    altgraph
    packaging
    macholib
    pyinstaller-hooks-contrib
  ];

  makeWrapperArgs = lib.optionals stdenv.hostPlatform.isLinux [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      glibc
      binutils
    ])
  ];

  pythonImportsCheck = [ "PyInstaller" ];

  nativeCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Tool to bundle a python application with dependencies into a single package";
    homepage = "https://pyinstaller.org/";
    changelog = "https://pyinstaller.org/en/v${finalAttrs.version}/CHANGES.html";
    downloadPage = "https://pypi.org/project/pyinstaller/";
    license = with lib.licenses; [
      mit
      asl20
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ h7x4 ];
    mainProgram = "pyinstaller";
  };
})
