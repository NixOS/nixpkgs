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

<<<<<<< HEAD
  outputs = [ "out" "dev" ];

  buildInputs = [ (stdenv.cc.cc.libgcc or null) ];

  nativeBuildInputs = [ autoPatchelfHook ];
=======
  nativeBuildInputs = [
    autoPatchelfHook
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase =
    let
      processor = stdenv.hostPlatform.uname.processor;
      sharedLibrary = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      runHook preInstall

      install -Dm555 lib/${processor}/discord_game_sdk${sharedLibrary} $out/lib/discord_game_sdk${sharedLibrary}

<<<<<<< HEAD
      install -Dm444 c/discord_game_sdk.h $dev/lib/include/discord_game_sdk.h

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://discord.com/developers/docs/game-sdk/sdk-starter-guide";
    description = "Library to allow other programs to interact with the Discord desktop application";
    license = licenses.unfree;
    maintainers = with maintainers; [ tomodachi94 ];
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "x86_64-windows" ];
  };
}
