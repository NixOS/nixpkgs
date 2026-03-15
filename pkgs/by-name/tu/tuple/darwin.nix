{
  pname,
  version,
  src,
  passthru,
  meta,

  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -a $src $out/Applications/Tuple.app
    runHook postInstall
  '';
}
