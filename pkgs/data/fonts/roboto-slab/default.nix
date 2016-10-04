{ stdenv, fetchurl }:

let
  # last commit on the directory containing the fonts in the upstream repository
  commit = "883939708704a19a295e0652036369d22469e8dc";
in
stdenv.mkDerivation rec {
  name = "roboto-slab-${version}";
  version = "2016-01-11";

  srcs = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotoslab/RobotoSlab-Regular.ttf";
      sha256 = "04180b5zk2nzll1rrgx8f1i1za66pk6pbrp0iww2xypjqra5zahk";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotoslab/RobotoSlab-Bold.ttf";
      sha256 = "0ayl2hf5j33vixxfa7051hzjjxnx8zhag3rr0mmmnxpsn7md44ms";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotoslab/RobotoSlab-Light.ttf";
      sha256 = "09riqgj9ixqjdb3mkzbs799cgmnp3ja3d6izlqkhpkfm52sgafqm";
    })
    (fetchurl {
      url = "https://raw.githubusercontent.com/google/fonts/${commit}/apache/robotoslab/RobotoSlab-Thin.ttf";
      sha256 = "1hd0m7lxhr261a4s2nb572ari6v53w2yd8yjr9i534iqfl4jcbsf";
    })
  ];

  sourceRoot = "./";

  unpackCmd = ''
    ttfName=$(basename $(stripHash $curSrc; echo $strippedName))
    cp $curSrc ./$ttfName
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a *.ttf $out/share/fonts/truetype/
  '';

  meta = {
    homepage = https://www.google.com/fonts/specimen/Roboto+Slab;
    description = "Google Roboto Slab fonts";
    longDescription = ''
      Roboto has a dual nature. It has a mechanical skeleton and the forms
      are largely geometric. At the same time, the font features friendly
      and open curves. While some grotesks distort their letterforms to
      force a rigid rhythm, Roboto doesn't compromise, allowing letters to
      be settled into their natural width. This makes for a more natural
      reading rhythm more commonly found in humanist and serif types.

      This is the Roboto Slab family, which can be used alongside the normal
      Roboto family and the Roboto Condensed family.
    '';
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.romildo ];
    platforms = stdenv.lib.platforms.all;
  };
}
