{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "encode-sans-1.002";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Encode-Sans";
    rev = "11162b46892d20f55bd42a00b48cbf06b5871f75";
    sha256 = "1v5k79qlsl6nggilmjw56axwwr2b3838x6vqch4lh0dck5ri9w2c";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    cp -v *.ttf $out/share/fonts/truetype/
    cp -v README.md FONTLOG.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    description = "A versatile sans serif font family";
    longDescription = ''
      The Encode Sans family is a versatile workhorse. Featuring a huge range of
      weights and widths, it's ready for all kind of typographic challenges. It
      also includes Tabular and Old Style figures, as well as full set of Small
      Caps and other Open Type features.

      Designed by Pablo Impallari and Andres Torresi.
    '';
    homepage = http://www.impallari.com/projects/overview/encode;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
