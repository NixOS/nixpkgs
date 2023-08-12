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
  version = "M5b";

  src = if stdenv.isDarwin then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos.tar.gz";
      hash = "sha256-Uknt1NrywmGs8YovlnN8TU8iaYgT1jeYP4SQCuK1u+I=";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux.tar.gz";
      hash = "sha256-CZLGA4fFFysxHkwedC8RBLmHWwr3BM8xqps7hN3TC/g=";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ ncurses6 zlib gmp ];

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
