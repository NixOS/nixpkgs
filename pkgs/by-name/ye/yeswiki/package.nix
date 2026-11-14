{
  stdenv,
  fetchurl,
  unzip,
}:
let
  version = "4.7.2";
in
stdenv.mkDerivation {
  pname = "yeswiki";
  inherit version;

  # The release archive contains the bundled PHP and JavaScript dependencies.
  src = fetchurl {
    url = "https://github.com/YesWiki/yeswiki/releases/download/v${version}/yeswiki-v${version}.zip";
    hash = "sha256-NItzFdkznFcm8PM9rHdTrL9dsOG3ahcjxVqz/P7kax0=";
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
