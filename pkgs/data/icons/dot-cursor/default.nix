{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "dot-cursor";
  version = "1.4";

  src = fetchzip {
    url = "https://github.com/id-ekaagr/dot-cursor/releases/download/x/${pname}-${version}.tar.gz";
    hash = "sha256-VPMt5zuKCyP4b0NosuO+pq0Cvjl9+95vX+NUTazK9Sw=";
  };

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dot-* $out/share/icons/
  '';

  meta = with lib; {
    description = "Red dot cursor for everything on windows and linux, designed for simplicity and focus.";
    homepage = "https://github.com/id-ekaagr/dot-cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      id-ekaagr
    ];
  };
}
