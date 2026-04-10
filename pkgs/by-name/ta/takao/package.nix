{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "takao";
  version = "00303.01";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/f/fonts-takao/fonts-takao_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-0wjHNv1yStp0q9D0WfwjgUYoUKcCrXA5jFO8PEVgq5k=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Japanese TrueType Gothic, P Gothic, Mincho, P Mincho fonts";
    homepage = "https://launchpad.net/takao-fonts";
    license = lib.licenses.ipa;
    maintainers = with lib.maintainers; [ serge ];
    platforms = lib.platforms.all;
  };
})
