{ lib
, autoPatchelfHook
, fetchurl
, gmp
, less
, makeWrapper
, libb2
, ncurses6
, openssl
, stdenv
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison-code-manager";
  version = "0.5.27";

  src = if stdenv.hostPlatform.isDarwin then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos.tar.gz";
      hash = "sha256-bmEmox+CfkGZP9GCfwDyspTult0WV+6jfQzehT33p8U=";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux.tar.gz";
      hash = "sha256-js7MgzJQShy6z1QNsIRwjtZfrNOGwUA001SWlKWgMoA=";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ gmp ncurses6 zlib ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv runtime $out/lib/runtime
    mv ui $out/ui
    mv unison $out/unison
    makeWrapper $out/unison/unison $out/bin/ucm \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libb2 openssl ]} \
      --prefix PATH ":" "${lib.makeBinPath [ less ]}" \
      --add-flags "--runtime-path $out/lib/runtime/bin/unison-runtime" \
      --set UCM_WEB_UI "$out/ui"
  '';

  meta = with lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = with licenses; [ mit bsd3 ];
    mainProgram = "ucm";
    maintainers = with maintainers; [ ceedubs sellout virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
