{
  lib,
  fetchurl,
  stdenv,
  unzip,
  writeText,
}:
let
  pname = "yeswiki";
  version = "4.4.4";
  channel = "doryphore";
in
stdenv.mkDerivation {
  inherit pname channel version;

  src = fetchurl {
    url = "https://repository.yeswiki.net/${channel}/${pname}-${channel}-${version}.zip";
    sha256 = "sha256-1gtDYdlEnk+RSYElE47lb2AgC1oGPmdBwVd3L4goHec=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase =
    let
      localConfig = writeText "wakka.config.php" ''
        <?php
          return require(getenv('YESWIKI_CONFIG'));
        ?>
      '';
    in
    ''
      runHook preInstall

      mkdir -p $out/
      cp -R . $out/
      cp ${localConfig} $out/wakka.config.php
      cd $out

      runHook postInstall
    '';

  meta = {
    description = "Publish, edit and share your content with a user-friendly tool for building collaborative platforms";
    license = lib.licenses.agpl3Plus;
    homepage = "https://www.yeswiki.net";
    maintainers = with lib.maintainers; [
      ppom
      mrflos
    ];
    platforms = lib.platforms.all;
  };
}
