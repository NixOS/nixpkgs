{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "vdrsymbols";
  version = "20100612";

  src = fetchurl {
    url = "http://andreas.vdr-developer.org/fonts/download/${pname}-ttf-${version}.tgz";
    hash = "sha256-YxB+JcDkta5are+OQyP/WKDL0vllgn0m26bU9mQ3C/Q=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out/share/fonts/truetype" *.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "DejaVu fonts with additional symbols used by VDR";
    homepage = "http://andreas.vdr-developer.org/fonts/";
    platforms = platforms.all;
    maintainers = with maintainers; [ ck3d ];

    # Copyright (c) 2003 by Bitstream, Inc. All Rights Reserved.
    # Copyright (c) 2006 by Tavmjong Bah. All Rights Reserved.
    # DejaVu changes are in public domain
    # See https://dejavu-fonts.github.io/License.html for details
    license = licenses.free;
  };
}
