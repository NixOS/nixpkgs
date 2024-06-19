{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "lmodern";
  version = "2.005";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${pname}/${pname}_${version}.orig.tar.gz";
    hash = "sha256-xlUuZt6rjW0pX4t6PKWAHkkv3PisGCj7ZwatZPAUNxk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/texmf-dist/
    mkdir -p $out/share/fonts/

    cp -r * $out/texmf-dist/
    cp -r fonts/{opentype,type1} $out/share/fonts/

    runHook postInstall
  '';

  meta = {
    description = "Latin Modern font";
  };
}
