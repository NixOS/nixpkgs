{
  stdenv,
  fetchurl,
  unzip,
}:
let
  version = "4.6.7";
in
stdenv.mkDerivation {
  pname = "yeswiki";
  inherit version;

  # The release archive contains the bundled PHP and JavaScript dependencies.
  src = fetchurl {
    url = "https://github.com/YesWiki/yeswiki/releases/download/v${version}/yeswiki-v${version}.zip";
    hash = "sha256-QgF08amdCh4q3E3/wat4e/KhIWMtBTkFJzT3p5m61FU=";
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
