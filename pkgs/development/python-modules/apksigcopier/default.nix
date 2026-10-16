{
  lib,
  apksigner,
  bash,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  setuptools,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "apksigcopier";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "apksigcopier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VuwSaoTv5qq1jKwgBTKd1y9RKUzz89n86Z4UBv7Q51o=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /bin/bash ${bash}/bin/bash
  '';

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  build-system = [ setuptools ];

  dependencies = [ click ];

  postBuild = ''
    make apksigcopier.1
  '';

  postInstall = ''
    installManPage apksigcopier.1
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ apksigner ]}"
  ];

  pythonImportsCheck = [ "apksigcopier" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Copy/extract/patch android apk signatures & compare APKs";
    mainProgram = "apksigcopier";
    longDescription = ''
      apksigcopier is a tool for copying android APK signatures from a signed
      APK to an unsigned one (in order to verify reproducible builds).
      It can also be used to compare two APKs with different signatures.
      Its command-line tool offers four operations:

      * copy signatures directly from a signed to an unsigned APK
      * extract signatures from a signed APK to a directory
      * patch previously extracted signatures onto an unsigned APK
      * compare two APKs with different signatures (requires apksigner)
    '';
    homepage = "https://github.com/obfusk/apksigcopier";
    changelog = "https://github.com/obfusk/apksigcopier/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ obfusk ];
  };
})
