{
  lib,
  stdenv,
  fetchurl,
  mkfontscale,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "termsyn";
  version = "1.8.7";

  src = fetchurl {
    url = "mirror://sourceforge/termsyn/termsyn-${finalAttrs.version}.tar.gz";
    sha256 = "15vsmc3nmzl0pkgdpr2993da7p38fiw2rvcg01pwldzmpqrmkpn6";
  };

  nativeBuildInputs = [ mkfontscale ];

  installPhase = ''
    install -m 644 -D *.pcf -t "$out/share/fonts"
    install -m 644 -D *.psfu -t "$out/share/kbd/consolefonts"
    mkfontdir "$out/share/fonts"
  '';

  meta = {
    description = "Monospaced font based on terminus and tamsyn";
    homepage = "https://sourceforge.net/projects/termsyn/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sophrosyne ];
  };
})
