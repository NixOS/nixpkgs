{stdenv, fetchzip}:

let
  version = "2014-11-11";
in fetchzip {
  name = "open-dyslexic-${version}";

  url = https://github.com/antijingoist/open-dyslexic/archive/f4b5ba89018b44d633608907e15f93fb3fabbabc.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf       -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*/README.md -d $out/share/doc/open-dyslexic
  '';

  sha256 = "045xc7kj56q4ygnjppm8f8fwqqvf21x1piabm4nh8hwgly42a3w2";

  meta = with stdenv.lib; {
    homepage = http://opendyslexic.org/;
    description = "Font created to increase readability for readers with dyslexia";
    license = "Bitstream Vera License (https://www.gnome.org/fonts/#Final_Bitstream_Vera_Fonts)";
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
