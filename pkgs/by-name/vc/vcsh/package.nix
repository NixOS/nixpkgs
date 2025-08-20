{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkg-config,
  git,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "vcsh";
  version = "2.0.8";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-VgRA3v5PIKwizmXoc8f/YMoMCDGFJK/m2uhq3EsT1xQ=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
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

  meta = with lib; {
    description = "Version Control System for $HOME";
    homepage = "https://github.com/RichiH/vcsh";
    changelog = "https://github.com/RichiH/vcsh/blob/v${version}/changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      ttuegel
      alerque
    ];
    platforms = platforms.unix;
    mainProgram = "vcsh";
  };
}
