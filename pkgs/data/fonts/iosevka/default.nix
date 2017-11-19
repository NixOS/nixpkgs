{
  stdenv, lib,
  fetchFromGitHub, fetchurl,
  runCommand, writeText,
  nodejs, ttfautohint, otfcc
}:

with lib;

let
  installPackageLock = import ./package-lock.nix { inherit fetchurl lib; };
in

let
  version = "1.13.3";
  name = "iosevka-${version}";
  src = fetchFromGitHub {
    owner = "be5invis";
    repo ="Iosevka";
    rev = "v${version}";
    sha256 = "0wfhfiahllq8ngn0mybvp29cfcm7b8ndk3fyhizd620wrj50bazf";
  };
in

stdenv.mkDerivation {
  inherit name version src;

  nativeBuildInputs = [ nodejs ttfautohint otfcc ];

  passAsFile = [ "installPackageLock" ];
  installPackageLock = installPackageLock ./package-lock.json;

  preConfigure = ''
    HOME=$TMPDIR
    source "$installPackageLockPath";
    npm --offline rebuild
  '';

  installPhase = ''
    fontdir=$out/share/fonts/iosevka

    mkdir -p $fontdir
    cp -v dist/iosevka*/ttf/*.ttf $fontdir
  '';

  meta = with stdenv.lib; {
    homepage = https://be5invis.github.io/Iosevka/;
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ cstrahan jfrankenau ];
  };
}
