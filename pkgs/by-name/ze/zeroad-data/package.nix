{
  lib,
  stdenv,
  fetchurl,
  zeroad-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "0ad-data";
  inherit (zeroad-unwrapped) version;

  src = fetchurl {
    url = "https://releases.wildfiregames.com/0ad-${finalAttrs.version}-unix-data.tar.xz";
    hash = "sha256-g34tbd8TiwJfwCAXJF11gaS7hP2UtCwOYF0yG3AXqZg=";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

  meta = {
    description = "Free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ chvp ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
  };
})
