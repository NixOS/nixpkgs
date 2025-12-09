{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "trimal";
  version = "1.5.1";

  src = fetchFromGitHub {
    repo = "trimal";
    owner = "scapella";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ maintainers.bzizou ];
  };
}
