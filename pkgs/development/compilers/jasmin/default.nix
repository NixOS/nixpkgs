{ lib
, stdenv
, fetchurl
, unzip
, ant
, jdk8
, makeWrapper
, canonicalize-jars-hook
, callPackage
}:

let
  jdk = jdk8;
  jre = jdk8.jre;

in stdenv.mkDerivation (finalAttrs: {
  pname = "jasmin";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/jasmin/jasmin-${finalAttrs.version}.zip";
    hash = "sha256-6qEMaM7Gggb9EC6exxE3OezNeQEIoblabow+k/IORJ0=";
  };

  nativeBuildInputs = [
    unzip
    ant
    jdk
    makeWrapper
    canonicalize-jars-hook
  ];

  buildPhase = ''
    runHook preBuild
    ant all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 jasmin.jar $out/share/java/jasmin.jar
    makeWrapper ${jre}/bin/java $out/bin/jasmin \
      --add-flags "-jar $out/share/java/jasmin.jar"

    runHook postInstall
  '';

  passthru.tests = {
    minimal-module = callPackage ./test-assemble-hello-world {};
  };

  meta = with lib; {
    description = "An assembler for the Java Virtual Machine";
    downloadPage = "https://sourceforge.net/projects/jasmin/files/latest/download";
    homepage = "https://jasmin.sourceforge.net/";
    license = licenses.bsd3;
    mainProgram = "jasmin";
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
