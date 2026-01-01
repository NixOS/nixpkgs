{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "trimal";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.5.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    repo = "trimal";
    owner = "scapella";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ONSkYceCgYGSpABj0iOx6yj2hMyFHqCHflYRW+Q6RVc=";
=======
    sha256 = "sha256-6GXirih7nY0eD2XS8aplLcYf53EeLuae+ewdUgBiKQQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postUnpack = ''
    sourceRoot=''${sourceRoot}/source
    echo Source root reset to ''${sourceRoot}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a trimal readal statal $out/bin
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ lib.maintainers.bzizou ];
=======
  meta = with lib; {
    description = "Tool for the automated removal of spurious sequences or poorly aligned regions from a multiple sequence alignment";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "http://trimal.cgenomics.org";
    maintainers = [ maintainers.bzizou ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
