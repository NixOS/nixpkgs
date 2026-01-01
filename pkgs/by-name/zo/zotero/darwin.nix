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
<<<<<<< HEAD
    hash = "sha256-lDf/jULLQyzxNVGRUKuF2df+FTbJK08z+fFQbVgwjsY=";
=======
    hash = "sha256-YivHBEFPkm79y2R5QIV+trm8O3aFzvXTqVzFr1tcoIo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
