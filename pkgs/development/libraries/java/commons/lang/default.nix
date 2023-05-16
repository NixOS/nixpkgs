<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.13.0";
  pname = "commons-lang";

  src = fetchurl {
    url = "mirror://apache/commons/lang/binaries/commons-lang3-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-yDEbe1wqyfxuJe2DK55YnNLKLh7JcsHAgp2OohWBwWU=";
  };

  installPhase = ''
    runHook preInstall
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
    runHook postInstall
  '';

  meta = {
    description = "Provides additional methods to manipulate standard Java library classes";
    homepage = "https://commons.apache.org/proper/commons-lang";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ copumpkin ];
    platforms = with lib.platforms; unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
=======
{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.12.0";
  pname = "commons-lang";

  src = fetchurl {
    url    = "mirror://apache/commons/lang/binaries/commons-lang3-${version}-bin.tar.gz";
    sha256 = "sha256-MwEkZd/Lf3kKyjM+CevxBeKl+5XCxjiz33kNPvqQjig=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage    = "https://commons.apache.org/proper/commons-lang";
    description = "Provides additional methods to manipulate standard Java library classes";
    maintainers = with lib.maintainers; [ copumpkin ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license     = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
