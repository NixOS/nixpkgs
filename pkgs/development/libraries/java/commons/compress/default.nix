{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "1.24.0";
=======
  version = "1.23.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "commons-compress";

  src = fetchurl {
    url    = "mirror://apache/commons/compress/binaries/${pname}-${version}-bin.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-VQzXg16rnrghsRY2H3NnGJ+0HEbz8/Num7Xlm9pEqqw=";
=======
    sha256 = "sha256-m+7cc7h9xVXKlLBTTr2L91AFWDTN+hNSycxDNO0oBAI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-compress";
    description = "Allows manipulation of ar, cpio, Unix dump, tar, zip, gzip, XZ, Pack200, bzip2, 7z, arj, lzma, snappy, DEFLATE and Z files";
    maintainers = with lib.maintainers; [ copumpkin ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
