{
  stdenvNoCC,
  lib,
  fetchurl,
  undmg,
  pname,
  version,
  sha256,
  metaCommon ? { },
}:

stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/the-via/releases/releases/download/v${version}/via-${version}-mac.dmg";
    name = "via-${version}-darwin.dmg";
    inherit sha256;
  };

  sourceRoot = "Via.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    mkdir -p "$out/Applications/Via.app"
    cp -R . "$out/Applications/Via.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/Via.app/Contents/MacOS/Via" "$out/bin/via"
  '';

  meta = metaCommon // {
    platforms = with lib.platforms; darwin;
  };
}
