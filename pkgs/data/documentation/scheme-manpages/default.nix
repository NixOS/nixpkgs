<<<<<<< HEAD
{ lib, stdenvNoCC, fetchFromGitHub, unstableGitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-08-13";
=======
{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "scheme-manpages";
  version = "unstable-2023-03-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "schemedoc";
    repo = "manpages";
<<<<<<< HEAD
    rev = "c17abb7dfb733fede4cf776a932e9696ccc7a4f2";
    hash = "sha256-9s/1sJEA4nowzQRpySOFzY+PxiUdz1Z3D931rMet4CA=";
=======
    rev = "eac67db33b2111f19ac267585032df8b4838e6f4";
    hash = "sha256-FBoagGHWsxZo40gOqeBUw0L+LtNAVF/q6IZ3N9QBFQs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/man
    cp -r man3/ man7/ $out/share/man/
  '';

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Unix manual pages for R6RS and R7RS";
    homepage = "https://github.com/schemedoc/manpages";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
