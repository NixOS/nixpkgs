{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cozette";
<<<<<<< HEAD
  version = "1.22.2";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts-v-${builtins.replaceStrings ["."] ["-"] version}.zip";
    hash = "sha256-Y6StCbAsFJrRZtJu1IAsMYuyNhwe3YIlT41EhSXhCUE=";
=======
  version = "1.19.2";

  src = fetchzip {
    url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts.zip";
    hash = "sha256-+TnKUgrAafR5irS9XeXWfb1a2PfUKOXf8CAmqJbf6y4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 *.otf -t $out/share/fonts/opentype
    install -Dm644 *.bdf -t $out/share/fonts/misc
    install -Dm644 *.otb -t $out/share/fonts/misc
<<<<<<< HEAD
    install -Dm644 *.woff -t $out/share/fonts/woff
    install -Dm644 *.woff2 -t $out/share/fonts/woff2
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

  meta = with lib; {
    description = "A bitmap programming font optimized for coziness";
    homepage = "https://github.com/slavfox/cozette";
<<<<<<< HEAD
    changelog = "https://github.com/slavfox/Cozette/blob/v.${version}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons marsam ];
  };
}
