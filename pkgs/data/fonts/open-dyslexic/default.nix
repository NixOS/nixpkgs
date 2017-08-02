{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  name = "open-dyslexic-${version}";
  version = "2014-11-11";

  src = fetchgit {
    url = "https://github.com/antijingoist/open-dyslexic.git";
    rev = "f4b5ba89018b44d633608907e15f93fb3fabbabc";
    sha256 = "04pa7c2cary6pqxsmxqrg7wi19szg7xh8panmvqvmc7jas0mzg6q";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp -v 'otf/'*.otf $out/share/fonts/opentype

    mkdir -p $out/share/doc/open-dyslexic
    cp -v README.md $out/share/doc/open-dyslexic
  '';

  meta = with stdenv.lib; {
    homepage = http://opendyslexic.org/;
    description = "Font created to increase readability for readers with dyslexia";
    license = "Bitstream Vera License (https://www.gnome.org/fonts/#Final_Bitstream_Vera_Fonts)";
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
