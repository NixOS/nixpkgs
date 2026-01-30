{
  pname,
  version,
  meta,
  stdenv,
  fetchurl,
  undmg,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://download.zotero.org/client/release/${finalAttrs.version}/Zotero-${finalAttrs.version}.dmg";
    hash = "sha256-lDf/jULLQyzxNVGRUKuF2df+FTbJK08z+fFQbVgwjsY=";
  };
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
})
