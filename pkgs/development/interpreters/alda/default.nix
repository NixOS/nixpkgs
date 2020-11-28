{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/alda-lang/alda/releases/download/${version}/alda";
    sha256 = "1c9rbwb3ga8w7zi0ndqq02hjr4drdw8s509qxxd3fh5vfy6x3qi2";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/alda
    sed -i -e '1 s!java!${jre}/bin/java!' $out/bin/alda
  '';

  meta = with stdenv.lib; {
    description = "A music programming language for musicians";
    homepage = "https://alda.io";
    license = licenses.epl10;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };

}
