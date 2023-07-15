{ lib, stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
, makeWrapper
, less
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison-code-manager";
  milestone_id = "M4i";
  version = "1.0.${finalAttrs.milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.milestone_id}/ucm-macos.tar.gz";
      hash = "sha256-1Qp1SB5rCsVimZzRo1NOX8HBoMEGlIycJPm3zGTUuOw=";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.milestone_id}/ucm-linux.tar.gz";
      hash = "sha256-Qx8vO/Vaz0VdCGXwIwRQIuMlp44hxCroQ7m7Y+m7aXk=";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);
  buildInputs = lib.optionals (!stdenv.isDarwin) [ ncurses5 zlib gmp ];

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
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
    mainProgram = "ucm";
  };
})
