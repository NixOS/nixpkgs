{ lib
, stdenv
, fetchzip
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "discord-gamesdk";
  version = "3.2.1";

  src = fetchzip {
    url = "https://dl-game-sdk.discordapp.net/${version}/discord_game_sdk.zip";
    sha256 = "sha256-83DgL9y3lHLLJ8vgL3EOVk2Tjcue64N+iuDj/UpSdLc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase =
    let
      processor = stdenv.hostPlatform.uname.processor;
      sharedLibrary = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      runHook preInstall

      install -Dm555 lib/${processor}/discord_game_sdk${sharedLibrary} $out/lib/discord_game_sdk${sharedLibrary}

      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://discord.com/developers/docs/game-sdk/sdk-starter-guide";
    description = "Library to allow other programs to interact with the Discord desktop application";
    license = licenses.unfree;
    maintainers = with maintainers; [ tomodachi94 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "x86_64-windows" ];
  };
}
