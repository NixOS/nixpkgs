<<<<<<< HEAD
{ lib
, autoPatchelfHook
, fetchurl
, gmp
, less
, makeWrapper
, ncurses6
, stdenv
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison-code-manager";
  version = "M5e";

  src = if stdenv.isDarwin then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos.tar.gz";
      hash = "sha256-jg8/DmIJru2OKZu5WfA7fatKcburPiXnoALifxL26kc=";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux.tar.gz";
      hash = "sha256-+2dIxqf9b8DfoTUakxA6Qrpb7cAQKCventxDS1sFxjM=";
=======
{ lib, stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
, makeWrapper
, less
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M4h";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/ucm-macos.tar.gz";
      hash = "sha256-7yphap7qZBkbTKiwhyCTLgbBO/aA0eUWtva+XjpaZDI=";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/ucm-linux.tar.gz";
      hash = "sha256-vrZpYFoQw1hxgZ7lAoejIqnjIOFFMahAI9SjFN/Cnms=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ ncurses6 zlib gmp ];
=======
  nativeBuildInputs = [ makeWrapper ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);
  buildInputs = lib.optionals (!stdenv.isDarwin) [ ncurses5 zlib gmp ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  installPhase = ''
    mkdir -p $out/bin
    mv ucm $out/bin
    mv ui $out/ui
    wrapProgram $out/bin/ucm \
      --prefix PATH ":" "${lib.makeBinPath [ less ]}" \
      --set UCM_WEB_UI "$out/ui"
  '';

  meta = with lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = with licenses; [ mit bsd3 ];
<<<<<<< HEAD
    mainProgram = "ucm";
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
=======
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
