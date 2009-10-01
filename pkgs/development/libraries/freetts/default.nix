{stdenv, fetchurl, apacheAnt, unzip, sharutils, lib}:

stdenv.mkDerivation {
  name = "freetts-1.2.2";
  src = fetchurl {
    url = mirror://sourceforge/freetts/freetts-1.2.2-src.zip;
    sha256 = "0mnikqhpf4f4jdr0irmibr8yy0dnffx1i257y22iamxi7a6by2r7";
  };
  buildInputs = [ apacheAnt unzip sharutils ];
  unpackPhase = ''
    unzip $src -x META-INF/*
  '';
  
  buildPhase = ''
    cd */lib
    sed -i -e "s/more/cat/" jsapi.sh
    echo y | sh jsapi.sh
    cd ..
    ln -s . src
    ant
  '';
  installPhase = ''
    install -v -m755 -d $out/{lib,docs/{audio,images}}
    install -v -m644 lib/*.jar $out/lib
  '';
  
  meta = {
    description = "Text to speech system based on Festival written in Java";
    longDescription = ''
      Text to speech system based on Festival written in Java.
      Can be used in combination with KDE accessibility.
    '';
    license = "GPL";
    homepage = http://freetts.sourceforge.net;
    maintainers = [ lib.maintainers.sander ];
  };
}
