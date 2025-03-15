{
  lib,
  autoPatchelfHook,
  fetchurl,
  gmp,
  less,
  makeWrapper,
  libb2,
  ncurses6,
  openssl,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unison-code-manager";
  version = "0.5.36";

  src =
    {
      aarch64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-arm64.tar.gz";
        hash = "sha256-GH0qZtb29qDxL39nArYSzCQ50/ssPOiN9CXnAvb9uVQ=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-x64.tar.gz";
        hash = "sha256-seL8Ey20KYVsOLugGvfVXXIIVdv7q04PYXh3c6MoZDk=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-x64.tar.gz";
        hash = "sha256-Zb91ixXd3ueQj6+YjC9Wgq3PnfcKBKZZdCJfS0nQOV4=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gmp
    ncurses6
    zlib
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv runtime $out/lib/runtime
    mv ui $out/ui
    mv unison $out/unison
    makeWrapper $out/unison/unison $out/bin/ucm \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libb2
          openssl
        ]
      } \
      --prefix PATH ":" "${lib.makeBinPath [ less ]}" \
      --add-flags "--runtime-path $out/lib/runtime/bin/unison-runtime" \
      --set UCM_WEB_UI "$out/ui"
  '';

  meta = with lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = with licenses; [
      mit
      bsd3
    ];
    mainProgram = "ucm";
    maintainers = with maintainers; [
      ceedubs
      sellout
      virusdave
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
