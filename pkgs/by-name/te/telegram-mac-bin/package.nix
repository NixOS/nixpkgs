{
  stdenv,
  lib,
  fetchzip,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "telegram-mac-bin";
  version = "11.11.272320";
  src = fetchzip {
    url = "https://osx.telegram.org/updates/Telegram-${version}.app.zip";
    sha256 = "iwueBSX22m/KIJvB+JC6RD8U0XOZSURyObfVjrcP5yw=";
  };

  buildPhase = ''
    mkdir -p $out/Applications/${meta.mainProgram}.app
    cp -r Contents $out/Applications/${meta.mainProgram}.app/
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

    update-source-version ${pname} $new_version $new_sha
  '';

  meta = with lib; {
    description = "Telegram for macOS";
    license = licenses.unfree;
    platforms = platforms.darwin;
    homepage = "https://mac.telegram.org/";
    maintainers = with maintainers; [ kecrily ];
    mainProgram = "Telegram";
  };
}
