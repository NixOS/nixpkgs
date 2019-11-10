{ stdenv
, fetchurl
, unzip
, jdk
, ant
, makeWrapper
, jre
, callPackage
}:

stdenv.mkDerivation rec {
  pname = "jasmin";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/jasmin/jasmin-${version}/jasmin-${version}.zip";
    sha256 = "17a41vr96glcdrdbk88805wwvv1r6w8wg7if23yhd0n6rrl0r8ga";
  };

  nativeBuildInputs = [ unzip jdk ant makeWrapper ];

  buildPhase = "ant all";
  installPhase =
  ''
    install -Dm644 jasmin.jar $out/share/java/jasmin.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/jasmin \
      --add-flags "-jar $out/share/java/jasmin.jar"
  '';

  passthru.tests = {
    minimal-module = callPackage ./test-assemble-hello-world {};
  };

  meta = with stdenv.lib; {
    description = "An assembler for the Java Virtual Machine";
    homepage = "http://jasmin.sourceforge.net/";
    downloadPage = "https://sourceforge.net/projects/jasmin/files/latest/download";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

