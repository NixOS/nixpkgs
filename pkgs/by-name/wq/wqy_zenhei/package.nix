{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wqy-zenhei";
  version = "0.9.45";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/${pname}-${version}.tar.gz";
    hash = "sha256-5LfjBkdb+UJ9F1dXjw5FKJMMhMROqj8WfUxC8RDuddY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttc -t $out/share/fonts/

    runHook postInstall
  '';

  meta = with lib; {
    description = "(mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = licenses.gpl2; # with font embedding exceptions
    maintainers = [ maintainers.pkmx ];
    platforms = platforms.all;
  };
}
