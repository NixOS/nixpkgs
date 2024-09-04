{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "fixedsys-excelsior";
  version = "3.00";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/chrissimpkins/codeface/master/fonts/fixed-sys-excelsior/FSEX300.ttf";
    hash = "sha256-buDzVzvF4z6TthbvYoL0m8DiJ6Map1Osdu0uPz0CBW0=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m444 -D $src $out/share/fonts/truetype/${pname}-${version}.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.fixedsysexcelsior.com/";
    description = "Pan-unicode version of Fixedsys, a classic DOS font";
    platforms = lib.platforms.all;
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.picnoir ];
  };
}
