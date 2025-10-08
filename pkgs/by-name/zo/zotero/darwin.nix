{
  channel,
  pname,
  version,
  src,
  passthru,
  meta,
  stdenv,
  fetchurl,
  undmg,
}:

stdenv.mkDerivation {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true; # breaks notarization

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Zotero.app $out/Applications

    runHook postInstall
  '';
}
