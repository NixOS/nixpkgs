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

  src = fetchurl {
    url = "https://download.zotero.org/client/release/${version}/Zotero-${version}.dmg";
    hash = "sha256-JFzzOwZUhVy7DsD6xehKhhzIKe9j8IKseJTSWhYAkfM=";
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
