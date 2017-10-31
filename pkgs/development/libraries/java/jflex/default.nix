{stdenv, fetchurl} :

stdenv.mkDerivation rec {
  name = "jflex-1.6.1";

  src = fetchurl {
    url = "http://jflex.de/${name}.tar.gz";
    sha256 = "1h7q2vhb4s42g4pqz5xxxliagprray7i9krr6hyaz1mjlx7gnycq";
  };

  sourceRoot = name;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a * $out
    patchShebangs $out
  '';

  meta = {
    homepage = http://www.jflex.de/;
    description = "Lexical analyzer generator for Java, written in Java";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
