{fetchurl, stdenv, fontforge, perl, fontconfig, FontTTF}:

let version = "2.29" ; in

stdenv.mkDerivation {
  name = "dejavu-fonts-${version}";
  #fontconfig is needed only for fc-lang (?)
  buildInputs = [fontforge perl FontTTF];
  src = fetchurl {
    url = "mirror://sourceforge/dejavu/dejavu-fonts-${version}.tar.bz2";
    sha256 = "1h8x0bnbh9awwsxiwjpp73iczk1y4d5y0as1f4zb4pbk6l2m7v60";
  };
  preBuild = ''
    sed -e s@/usr/bin/env@$(type -tP env)@ -i scripts/*
    sed -e s@/usr/bin/perl@$(type -tP perl)@ -i scripts/*
    mkdir resources
    tar xf ${fontconfig.src} --wildcards '*/fc-lang'
    ln -s $PWD/fontconfig-*/fc-lang -t resources/
    ln -s ${perl}/lib/*/*/unicore/* -t resources/
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
  
