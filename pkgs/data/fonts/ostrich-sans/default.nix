{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ostrich-sans";
  version = "2014-04-18";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "a949d40d0576d12ba26e2a45e19c91fd0228c964";
    hash = "sha256-vvTNtl+fO2zWooH1EvCmO/dPYYgCkj8Ckg5xfg1gtnw=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "A gorgeous modern sans-serif with a very long neck";
    longDescription = ''
      A gorgeous modern sans-serif with a very long neck. With a whole slew of
      styles & weights.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/ostrich-sans";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
