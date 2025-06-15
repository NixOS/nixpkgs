{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeWrapper,
  pkg-config,
  automake,
  autoconf,
  git,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vcsh";
  version = "2.0.10";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/releases/download/v${finalAttrs.version}/vcsh-${finalAttrs.version}.zip";
    hash = "sha256-M/UME2kNCxwzngKXMYp0cdps7LWVwoS2I/mTrvPts7g=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    unzip
    automake
    autoconf
  ];

  buildInputs = [ git ];

  nativeCheckInputs =
    [ ]
    ++ (with perlPackages; [
      perl
      ShellCommand
      TestMost
    ]);

  outputs = [
    "out"
    "doc"
    "man"
  ];

  meta = {
    description = "Version Control System for $HOME";
    homepage = "https://github.com/RichiH/vcsh";
    changelog = "https://github.com/RichiH/vcsh/blob/v${finalAttrs.version}/changelog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ttuegel
      alerque
    ];
    platforms = lib.platforms.unix;
    mainProgram = "vcsh";
  };
})
