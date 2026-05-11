{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trimal";
  version = "1.5.1";

  src = fetchFromGitHub {
    repo = "trimal";
    owner = "scapella";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ONSkYceCgYGSpABj0iOx6yj2hMyFHqCHflYRW+Q6RVc=";
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a trimal readal statal $out/bin
  '';

  meta = {
    description = "Tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ lib.maintainers.bzizou ];
  };
})
