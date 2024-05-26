{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "dot-cursor";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "id-ekaagr";
    repo = "dot-cursor";
    rev = "v${version}";
    sha256 = "VPMt5zuKCyP4b0NosuO+pq0Cvjl9+95vX+NUTazK9Sw=";
  };

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dot-* $out/share/icons/
  '';

  meta = {
    description = "Red dot cursor for everything on windows and linux, designed for simplicity and focus.";
    homepage = "https://github.com/id-ekaagr/dot-cursor";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      id-ekaagr
    ];
  };
}
