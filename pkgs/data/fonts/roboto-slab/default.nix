{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "roboto-slab";
  version = "2.000";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "robotoslab";
    rev = "baeeba45e0c3ccdcfb6a70dc564785941aafef5d";
    sha256 = "1v6z0a2xgwgf9dyj62sriy8ckwpbwlxkki6gfax1f4h4livvzpdn";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -a fonts/static/*.ttf $out/share/fonts/truetype/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0g663npi5lkvwcqafd4cjrm90ph0nv1lig7d19xzfymnj47qpj8x";

  meta = with lib; {
    homepage = "https://www.google.com/fonts/specimen/Roboto+Slab";
    description = "Roboto Slab Typeface by Google";
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
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
