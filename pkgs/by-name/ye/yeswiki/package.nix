{
  stdenv,
  fetchurl,
  unzip,
}:
let
  version = "4.4.2";
in
stdenv.mkDerivation {
  pname = "yeswiki";
  inherit version;

  src = fetchurl {
    url = "https://repository.yeswiki.net/doryphore/yeswiki-doryphore-${version}.zip";
    hash = "sha256-TNiVBragEnLkMTu/Op6sCFsk9wWXUQ2GUPqmWgPV/vk=";
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
