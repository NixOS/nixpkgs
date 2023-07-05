{ lib, stdenv, fetchurl, makeWrapper, jdk }:

stdenv.mkDerivation rec {
  pname = "lombok";
  version = "1.18.28";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/lombok-${version}.jar";
    sha256 = "sha256-t3TcT8pUMiXYtejBY360E8Q2Oy5hPpUiJ3b3kqjOwOA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  outputs = [ "out" "bin" ];

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar

    makeWrapper ${jdk}/bin/java $bin/bin/lombok \
      --add-flags "-cp ${jdk}/lib/openjdk/lib/tools.jar:$out/share/java/lombok.jar" \
      --add-flags lombok.launch.Main
  '';

  meta = {
    description = "A library that can write a lot of boilerplate for your Java project";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.mit;
    homepage = "https://projectlombok.org/";
    maintainers = [ lib.maintainers.CrystalGamma ];
  };
}
