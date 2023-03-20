{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (self: {
  pname = "fanwood";
  version = "2011-05-11";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = self.pname;
    rev = "cbaaed9704e7d37d3dcdbdf0b472e9efd0e39432";
    hash = "sha256-OroFhhb4RxPHkx+/8PtFnxs1GQVXMPiYTd+2vnRbIjg=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "A serif based on the work of a famous Czech-American type designer of yesteryear";
    longDescription = ''
      Based on work of a famous Czech-American type designer of yesteryear. The
      package includes roman and italic.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/fanwood";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
