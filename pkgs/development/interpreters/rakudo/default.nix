{
  fetchFromGitHub,
  lib,
  nqp,
  perl,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rakudo";
  version = "2025.11";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-S+IOzCVgasmdZYBKuujaHrUufJ8ZDjIRNQbARTn6iyk=";
  };

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${lib.getExe nqp}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Raku implementation on top of Moar virtual machine";
    homepage = "https://rakudo.org";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
    mainProgram = "rakudo";
  };
})
