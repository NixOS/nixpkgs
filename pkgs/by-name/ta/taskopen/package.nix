{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  which,
  perl,
  perlPackages,
  buildNimPackage,
  git,
}:

buildNimPackage (finalAttrs: {
  pname = "taskopen";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "jschlatow";
    repo = "taskopen";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-0SAiSaN9V1JYnyJsWda6unqUlyXRL8y8JHXP4VNAFhM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    export HOME=$(pwd)
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = {
    description = "Script for taking notes and open urls with taskwarrior";
    mainProgram = "taskopen";
    homepage = "https://github.com/ValiValpas/taskopen";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.winpat ];
  };
})
