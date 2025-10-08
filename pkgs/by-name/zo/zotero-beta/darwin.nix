{
  pname,
  version,
  meta,
  stdenv,
  fetchurl,
  undmg,
}:

stdenv.mkDerivation rec {
  inherit pname version meta;

  src =
    let
      escapedVersion = lib.escapeURL version;
    in
    fetchurl {
      url = "https://download.zotero.org/client/beta/${escapedVersion}/Zotero-${escapedVersion}.dmg";
      hash = "sha256-LBFfBWsitApSdg41vsKT6i5Yk6NNLc7FV+BJGVmHv7E=";
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
}
