{
  stdenv,
  fetchurl,
  unzip,
}:
let
  version = "4.6.8";
in
stdenv.mkDerivation {
  pname = "yeswiki";
  inherit version;

  # The release archive contains the bundled PHP and JavaScript dependencies.
  src = fetchurl {
    url = "https://github.com/YesWiki/yeswiki/releases/download/v${version}/yeswiki-v${version}.zip";
    hash = "sha256-AvGFZhY8qw9yewjAl5PlU/08XEFnOtNoQSGXlY9l8PI=";
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
