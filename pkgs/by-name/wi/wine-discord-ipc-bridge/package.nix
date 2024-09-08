{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "wine-discord-ipc-bridge";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "0e4ef622";
    repo = "wine-discord-ipc-bridge";
    rev = "f8198c9d52e708143301017a296f7557c4387127";
    hash = "sha256-tAknITFlG63+gI5cN9SfUIUZkbIq/MgOPoGIcvoNo4Q=";
  };

  postPatch = ''
    patchShebangs winediscordipcbridge-steam.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp winediscordipcbridge.exe $out/bin
    cp winediscordipcbridge-steam.sh $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Enable games running under wine to use Discord Rich Presence";
    homepage = "https://github.com/0e4ef622/wine-discord-ipc-bridge";
    license = licenses.mit;
    maintainers = [ maintainers.uku3lig ];
    mainProgram = "winediscordipcbridge";
    platforms = [ "mingw32" ];
  };
}
