{lib, stdenv, fetchurl, jre} :

stdenv.mkDerivation rec {
  pname = "jflex";
  version = "1.8.2";

  src = fetchurl {
    url = "http://jflex.de/release/jflex-${version}.tar.gz";
    sha256 = "1ar7g6zb2xjgnws3j4cqcp86jplhc9av8cpcjdmxw08x6igd5q51";
  };

  sourceRoot = "${pname}-${version}";

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
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
