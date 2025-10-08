{
  pname,
  version,
  src,
  meta,
  stdenv,
  fetchurl,
  undmg,
}:

stdenv.mkDerivation rec {
  inherit
    pname
    version
    src
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

  passthru.updateScript = ./update.sh;
}
