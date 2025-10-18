{
  fetchFromGitHub,
  lib,
  nqp,
  perl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rakudo";
  version = "2025.12";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "rakudo";
    repo = "rakudo";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-rCLlLxFexk2fzuuSMrJjbwhgU+HgJNX6Ect6uCsuJmo=";
  };

  configureScript = "${lib.getExe perl} ./Configure.pl";
  configureFlags = [
    "--backends=moar"
    "--with-nqp=${lib.getExe nqp}"
  ];

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
