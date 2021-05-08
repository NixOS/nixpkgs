{ lib, stdenv, fetchurl, mkfontscale }:

stdenv.mkDerivation rec {
  pname = "termsyn";
  version = "1.8.7";

  src = fetchurl {
    url = "mirror://sourceforge/termsyn/termsyn-${version}.tar.gz";
    sha256 = "15vsmc3nmzl0pkgdpr2993da7p38fiw2rvcg01pwldzmpqrmkpn6";
  };

  nativeBuildInputs = [ mkfontscale ];

  installPhase = ''
    install -m 644 -D *.pcf -t "$out/share/fonts"
    install -m 644 -D *.psfu -t "$out/share/kbd/consolefonts"
    mkfontdir "$out/share/fonts"
  '';

  meta = with lib; {
    description = "Monospaced font based on terminus and tamsyn";
    homepage = "https://sourceforge.net/projects/termsyn/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sophrosyne ];
  };
}
