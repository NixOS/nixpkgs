{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.3.4";
=======
  version = "1.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "commons-daemon";

  src = fetchurl {
    url    = "mirror://apache/commons/daemon/binaries/commons-daemon-${version}-bin.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-n9zmdPC4nLs/Rnth9uojkc5Kg5IfgERbr08TOvENR0Q=";
=======
    sha256 = "sha256-FVWmj20LiigRvfK82363Wy8/ie9+wlIlRx49AwQnhOA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-daemon";
    description = "Apache Commons Daemon software is a set of utilities and Java support classes for running Java applications as server processes.";
    maintainers = with lib.maintainers; [ rsynnest ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
