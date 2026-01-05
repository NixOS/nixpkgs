{
  fetchFromGitHub,
  lib,
  moarvm,
  perl,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nqp";
  version = "2025.12";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "Raku";
    repo = "nqp";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-Ofu6mf2Vx7a1OrqWLnVvgnChWHFK+cSr803VZY2TYC8=";
  };

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-moar=${lib.getExe moarvm}"
  ];

  # Fix for issue where nqp expects to find files from moarvm in the same output:
  # https://github.com/Raku/nqp/commit/e6e069507de135cc71f77524455fc6b03b765b2f
  preBuild = ''
    share_dir="share/nqp/lib/MAST"
    mkdir -p $out/$share_dir
    ln -fs ${moarvm}/$share_dir/{Nodes,Ops}.nqp $out/$share_dir
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lightweight Raku-like environment for virtual machines";
    homepage = "https://github.com/Raku/nqp";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
    mainProgram = "nqp";
  };
})
