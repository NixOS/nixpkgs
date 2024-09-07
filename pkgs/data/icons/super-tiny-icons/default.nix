{ pkgs, lib, stdenvNoCC, fetchFromGitHub, }:

stdenvNoCC.mkDerivation {
  pname = "super-tiny-icons";
  version = "unstable-2023-11-06";

  src = fetchFromGitHub {
    owner = "edent";
    repo = "SuperTinyIcons";
    rev = "888f449af8fb8df93241204e99fece85b9d225a5";
    hash = "sha256-L/7CEvG0NPbF8+ysiEHPiPnCMAW3cUu/e3XwtatRdbg=";
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
