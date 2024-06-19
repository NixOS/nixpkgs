{lib, stdenv, fetchurl, jre} :

stdenv.mkDerivation rec {
  pname = "jflex";
  version = "1.9.1";

  src = fetchurl {
    url = "http://jflex.de/release/jflex-${version}.tar.gz";
    sha256 = "sha256-4MHp7vkf9t8E1z+l6v8T86ArZ5/uFHTlzK4AciTfbfY=";
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
    mainProgram = "jflex";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
