{ pkgs, lib, stdenvNoCC, fetchFromGitHub, }:

stdenvNoCC.mkDerivation {
  pname = "super-tiny-icons";
<<<<<<< HEAD
  version = "unstable-2023-05-22";
=======
  version = "unstable-2022-11-07";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "edent";
    repo = "SuperTinyIcons";
<<<<<<< HEAD
    rev = "69689fc05d6a14a865723a01b67c1af4741ed357";
    sha256 = "F1Qw1SLP7+LEiUch0YjBXQcpfU17YLCBk8q6cM77plU=";
=======
    rev = "b4d5a3be04c99ec0a309ac9e0d0b21207c237c7d";
    sha256 = "670ndAuBrZBr7YOTQm2zHJfpiBC56aPk+ZKMneREEoI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/SuperTinyIcons
    find $src/images -type d -exec cp -r {} $out/share/icons/SuperTinyIcons/ \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Miniscule SVG versions of common logos";
    longDescription = ''
      Super Tiny Web Icons are minuscule SVG versions of your favourite logos.
      The average size is under 568 bytes!
    '';
    homepage = "https://github.com/edent/SuperTinyIcons";
    license = licenses.mit;
    maintainers = [ maintainers.h7x4 ];
    platforms = platforms.all;
  };
}
