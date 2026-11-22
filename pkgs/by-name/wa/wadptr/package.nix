{
  lib,
  stdenv,
  fetchFromGitHub,
  deutex,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wadptr";
  version = "3.8";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fragglet";
    repo = "wadptr";
    tag = "wadptr-${finalAttrs.version}";
    hash = "sha256-/ZbhTMqu/5DPALu/06kfdbQJTv5nu54dvZ7kPVbFtac=";
  };

  postPatch = ''
    patchShebangs run_tests.sh
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [ deutex ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "wadptr-(.*)"
    ];
  };

  meta = {
    description = "Tool for compressing Doom WAD files";
    homepage = "https://soulsphere.org/projects/wadptr";
    changelog = "https://github.com/fragglet/wadptr/releases/tag/wadptr-${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "wadptr";
  };
})
