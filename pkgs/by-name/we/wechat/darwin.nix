{
  pname,
  version,
  src,
  meta,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -a WeChat.app $out/Applications

    runHook postInstall
  '';
}
