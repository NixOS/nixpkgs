args: with args;

stdenv.mkDerivation {
  name = "dejavu-fonts-2.23";
  #fontconfig is needed only for fc-lang (?)
  buildInputs = [fontforge perl perlFontTTF];
  src = fetchurl {
    url = mirror://sourceforge/dejavu/dejavu-fonts-2.23.tar.bz2;
    sha256 = "0gifaxiianls54i05yw5gxhi2a0j9jmy5p0q58ym4l9fxv5drnhn";
  };
  preBuild = ''
    sed -e s@/usr/bin/env@$(type -tP env)@ -i scripts/*
    sed -e s@/usr/bin/perl@$(type -tP perl)@ -i scripts/*
    mkdir resources
    tar xf ${fontconfig.src} --wildcards '*/fc-lang'
    ln -s $PWD/fontconfig-*/fc-lang resources/
    ln -s ${perl}/lib/*/unicore/* resources/
  '';
  installPhase = '' 
    ensureDir $out/share/fonts/truetype
    for i in $(find build -name '*.ttf'); do 
        cp $i $out/share/fonts/truetype; 
    done;
    ensureDir $out/share/dejavu-fonts
    cp -r build/* $out/share/dejavu-fonts
  '';
}
  
