{
  stdenv,
  fetchurl,
  unzip,
}:
let
  version = "4.7.0";
in
stdenv.mkDerivation {
  pname = "yeswiki";
  inherit version;

  # The release archive contains the bundled PHP and JavaScript dependencies.
  src = fetchurl {
    url = "https://github.com/YesWiki/yeswiki/releases/download/v${version}/yeswiki-v${version}.zip";
    hash = "sha256-0JLb4Eq+Nsniq1fzyFC3Zrwik2AQltCYDB/S15KfBwM=";
  };

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -R . $out/
    runHook postInstall
  '';
}
