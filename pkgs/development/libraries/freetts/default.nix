{stdenv, fetchurl, apacheAnt, unzip, sharutils, lib, jdk}:

stdenv.mkDerivation rec {
  pname = "freetts";
  version = "1.2.2";
  src = fetchurl {
    url = "mirror://sourceforge/freetts/${pname}-${version}-src.zip";
    sha256 = "0mnikqhpf4f4jdr0irmibr8yy0dnffx1i257y22iamxi7a6by2r7";
  };
  nativeBuildInputs = [ unzip ];
  buildInputs = [ apacheAnt sharutils jdk ];
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
    homepage = "http://freetts.sourceforge.net";
    maintainers = [ lib.maintainers.sander ];
  };
}
