{
  stdenvNoCC,
  lib,
  fetchzip,
  writeScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "telegram-mac-bin";
  version = "13.2.0.283494";
  src = fetchzip {
    url = "https://osx.telegram.org/updates/Telegram-${finalAttrs.version}.app.zip";
    hash = "sha256-fkKpEcpQkufr2k0xDm354ii21mXYf7GeXDe0vCeAIYI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = with finalAttrs.meta; ''
    runHook preInstall

    mkdir -p $out/Applications/${mainProgram}.app
    cp -r Contents $out/Applications/${mainProgram}.app/

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-telegram-mac" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts libxml2

    xml_data=$(curl -s https://osx.telegram.org/updates/versions.xml)

    version=$(echo "$xml_data" | xmllint --xpath "string(//channel/item[1]/enclosure/@*[local-name()='version'])" -)
    short_version=$(echo "$xml_data" | xmllint --xpath "string(//channel/item[1]/enclosure/@*[local-name()='shortVersionString'])" -)
    url=$(echo "$xml_data" | xmllint --xpath "string(//channel/item[1]/enclosure/@url)" -)

    new_version="$short_version.$version"
    sha256=$(nix-prefetch-url --unpack --name source $url)
    new_sha=$(nix hash convert --to base64 sha256:$sha256)

    update-source-version ${finalAttrs.pname} $new_version $new_sha
  '';

  meta = {
    description = "Telegram for macOS";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    homepage = "https://mac.telegram.org/";
    maintainers = with lib.maintainers; [ kecrily ];
    mainProgram = "Telegram";
  };
})
