{stdenv, fetchurl, jre} :

stdenv.mkDerivation rec {
  name = "jflex-1.8.2";

  src = fetchurl {
    url = "http://jflex.de/release/${name}.tar.gz";
    sha256 = "1ar7g6zb2xjgnws3j4cqcp86jplhc9av8cpcjdmxw08x6igd5q51";
  };

  sourceRoot = name;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a * $out
    rm -f $out/bin/jflex.bat

    patchShebangs $out
    sed -i -e '/^JAVA=java/ s#java#${jre}/bin/java#' $out/bin/jflex
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/jflex --version
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://www.jflex.de/";
    description = "Lexical analyzer generator for Java, written in Java";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
