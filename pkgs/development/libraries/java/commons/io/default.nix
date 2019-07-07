{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.6";
  name    = "commons-io-${version}";

  src = fetchurl {
    url    = "mirror://apache/commons/io/binaries/${name}-bin.tar.gz";
    sha256 = "1nzkv8gi56l1m4h7s8bcvqm0naq3bhh7fazcmgdhcr2zkjs5zfmn";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "http://commons.apache.org/proper/commons-io";
    description = "A library of utilities to assist with developing IO functionality";
    maintainers = with stdenv.lib.maintainers; [ copumpkin ];
    license     = stdenv.lib.licenses.asl20;
    platforms = with stdenv.lib.platforms; unix;
  };
}
