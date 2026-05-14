{
  lib,
  buildNimPackage,
  fetchFromGitHub,
}:
buildNimPackage {
  pname = "tridactyl-native";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tridactyl";
    repo = "native_messenger";
    rev = "3059abd9fb3f14d598f6c299335c3ebac5bc689a";
    hash = "sha256-gicdpWAoimZMNGLc8w0vtJiFFxeqxB8P4lgWDun7unM=";
  };

  lockFile = ./lock.json;

  installPhase = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -i -e "s|REPLACE_ME_WITH_SED|$out/bin/native_main|" "tridactyl.json"
    cp tridactyl.json "$out/lib/mozilla/native-messaging-hosts/"
  '';

  meta = {
    description = "Native messenger for Tridactyl, a vim-like Firefox webextension";
    mainProgram = "native_main";
    homepage = "https://github.com/tridactyl/native_messenger";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      timokau
      dit7ya
      kiike
    ];
  };
}
