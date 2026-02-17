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
  version = "1.1.0";

  src =
    {
      aarch64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-arm64.tar.gz";
        hash = "sha256-KE2kl3N6zs/snnb/8uNHSvJLp9tdKCqQRpHvAuOuQiQ=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-x64.tar.gz";
        hash = "sha256-eoN8VXN1LfKU7sLN6C5B9Eu2tepcxe0B1gcClVIzdxA=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-arm64.tar.gz";
        hash = "sha256-x8mP0iZIe9w0bCXHnccGa3kfOMCVq6NZUhnL0hqBl2M=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-x64.tar.gz";
        hash = "sha256-JucU3VrCK+cOkbWzPdp7u3LMa+I72y/W2QqOuwFLN3U=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}");

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gmp
    ncurses6
    zlib
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}

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
      --set UCM_WEB_UI "$out/ui"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = [
      lib.licenses.mit
      lib.licenses.bsd3
    ];
    mainProgram = "ucm";
    maintainers = [
      lib.maintainers.ceedubs
      lib.maintainers.sellout
      lib.maintainers.virusdave
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
