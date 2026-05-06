{
  lib,
  fetchurl,
  _7zz,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tableplus";
  version = "662";
  src = fetchurl {
    url = "https://files.tableplus.com/macos/${finalAttrs.version}/TablePlus.dmg";
    hash = "sha256-VR0sSTZfRjjv+p4DcYciKBJG5DHIwj4KLhTHPGRsSX0=";
  };

  sourceRoot = "TablePlus.app";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/TablePlus.app"
    cp -R . "$out/Applications/TablePlus.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/TablePlus.app/Contents/MacOS/TablePlus" "$out/bin/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = {
    description = "Database management made easy";
    homepage = "https://tableplus.com";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ yamashitax ];
    platforms = lib.platforms.darwin;
  };
})
