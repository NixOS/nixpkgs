{
  lib,
  stdenv,
  fetchurl,
  jre,
}:
stdenv.mkDerivation rec {
  pname = "zxing";
  version = "3.1.0";
  # Maven builds are hard to get right
  core_jar = fetchurl {
    url = "http://repo1.maven.org/maven2/com/google/zxing/core/${version}/core-${version}.jar";
    sha256 = "199l4xvlcpafqn69r3k9qjpqkw9lvkl02hzpm0ackvdhl7vk42zh";
  };
  javase_jar = fetchurl {
    url = "http://repo1.maven.org/maven2/com/google/zxing/javase/${version}/javase-${version}.jar";
    sha256 = "0fzxvvf5dqyrs5m9rqw4ffm9h1s27bi7q3jb1dam34s80q2rp2zq";
  };
  inherit jre;
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/lib/java" "$out/bin"
    cp "${core_jar}" "${javase_jar}" "$out/lib/java"
    substituteAll "${./java-zxing.sh}" "$out/bin/java-zxing"
    substituteAll "${./zxing-cmdline-runner.sh}" "$out/bin/zxing-cmdline-runner"
    substituteAll "${./zxing-cmdline-encoder.sh}" "$out/bin/zxing-cmdline-encoder"
    substituteAll "${./zxing.sh}" "$out/bin/zxing"
    chmod a+x "$out/bin"/*
    cd "$out/lib/java"; for i in *.jar; do mv "$i" "''${i#*-}"; done
  '';
  meta = {
    description = "1D and 2D code reading library";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zxing/zxing";
  };
}
