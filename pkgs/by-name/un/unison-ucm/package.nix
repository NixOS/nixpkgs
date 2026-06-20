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
  version = "1.3.0";

  src =
    {
      aarch64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-arm64.tar.gz";
        hash = "sha256-DBNZx90rLqeRrjAnscamI8sduIH966az+AfMpWzberk=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-x64.tar.gz";
        hash = "sha256-ei/w82erwVf3oLbXcisBkPv2/k4gvwSxshTg7PWijhw=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-arm64.tar.gz";
        hash = "sha256-6XRr8IOwRhZlGFD9xb29cvqqYVjZFzSvh3S52Cq4HMo=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-x64.tar.gz";
        hash = "sha256-DFLiI3Rro2ApmT84xndGdaLWH/Ad/HXEY6bj331tQzs=";
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
