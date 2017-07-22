{ pkgs, system, stdenv, fetchFromGitHub, nodejs, ttfautohint, otfcc }:

with stdenv.lib;

let
  nodePackages = import ./composition.nix {
    inherit pkgs system nodejs;
  };
in
stdenv.mkDerivation rec {
  name = "iosevka-${version}";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo ="Iosevka";
    rev = "v1.13.3";
    sha256 = "0103rjxcp2sis42xp7fh7g8i03h5snvs8n78lgsf79g8ssw0p9d4";
  };

  nativeBuildInputs = [ nodejs ttfautohint otfcc ] ++ (with nodePackages; [
    bezier-js
    caryll-shapeops
    cubic2quad
    libspiro-js
    object-assign
    otfcc-c2q
    pad
    patel
    toml
    topsort
    unorm
    yargs
   ]);

  prePatch = ''
    substituteInPlace utility/scripts.mk --replace \
      'patel/bin' '.bin'
  '';

  preConfigure = ''
    mkdir -p node_modules/.bin
    ${concatStrings (map (dep: ''
      test -d ${dep}/bin && (for b in $(ls ${dep}/bin); do
        ln -sv -t node_modules/.bin ${dep}/bin/$b
      done)
    '') nativeBuildInputs)}
    true
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
