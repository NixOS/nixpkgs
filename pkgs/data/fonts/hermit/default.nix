{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hermit";
  version = "2.0";

  src = fetchzip {
    url = "https://pcaro.es/d/otf-${pname}-${version}.tar.gz";
    stripRoot = false;
    hash = "sha256-RYXZ2yJ8BIxsgeEwhXz7g0NnWG3kMPZoJaOLMUQyWWQ=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype *.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "monospace font designed to be clear, pragmatic and very readable";
    homepage = "https://pcaro.es/p/hermit";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
