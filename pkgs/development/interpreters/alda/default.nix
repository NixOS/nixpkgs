{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "alda";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/alda-lang/alda/releases/download/${version}/alda";
    sha256 = "1d0412jw37gh1y7i8cmaml8r4sn516i6pxmm8m16yprqmz6glx28";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/alda
    sed -i -e '1 s!java!${jre}/bin/java!' $out/bin/alda
  '';

  meta = with stdenv.lib; {
    description = "A music programming language for musicians.";
    homepage = "https://alda.io";
    license = licenses.epl10;
    maintainers = [ maintainers.ericdallo ];
    platforms = jre.meta.platforms;
  };

}
