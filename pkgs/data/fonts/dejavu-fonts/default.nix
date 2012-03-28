{fetchurl, stdenv, fontforge, perl, fontconfig, FontTTF}:

let version = "2.33" ; in

stdenv.mkDerivation rec {
  name = "dejavu-fonts-${version}";
  #fontconfig is needed only for fc-lang (?)
  buildInputs = [fontforge perl FontTTF];

  unicodeData = fetchurl {
    url = http://www.unicode.org/Public/6.1.0/ucd/UnicodeData.txt ; 
    sha256 = "1bd6zkzvxfnifrn5nh171ywk7q56sgk8gdvdn43z9i53hljjcrih";
  };
  blocks = fetchurl {
    url = http://www.unicode.org/Public/6.1.0/ucd/Blocks.txt; 
    sha256 = "0w0vkb09nrlc6mrhqyl9npszdi828afgvhvlb1vs5smjv3h8y3dz";
  };

  src = fetchurl {
    url = "mirror://sourceforge/dejavu/dejavu-fonts-${version}.tar.bz2";
    sha256 = "10m0rds36yyaznfqaa9msayv6f0v1h50zbikja6qdy5dwwxi8q5w";
  };
  buildFlags = "full-ttf";
  preBuild = ''
    sed -e s@/usr/bin/env@$(type -tP env)@ -i scripts/*
    sed -e s@/usr/bin/perl@$(type -tP perl)@ -i scripts/*
    mkdir resources
    tar xf ${fontconfig.src} --wildcards '*/fc-lang'
    ln -s $PWD/fontconfig-*/fc-lang -t resources/
    ln -s ${unicodeData} resources/UnicodeData.txt
    ln -s ${blocks} resources/Blocks.txt
  '';
  installPhase = '' 
    mkdir -p $out/share/fonts/truetype
    for i in $(find build -name '*.ttf'); do 
        cp $i $out/share/fonts/truetype; 
    done;
    mkdir -p $out/share/dejavu-fonts
    cp -r build/* $out/share/dejavu-fonts
  '';
}
  
