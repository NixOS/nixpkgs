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
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "0.5.50";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src =
    {
      aarch64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-arm64.tar.gz";
<<<<<<< HEAD
        hash = "sha256-yEV6wQge9LJ9tp2So85Q7DN/8LmmSJ9vgU1lYezdp5o=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-x64.tar.gz";
        hash = "sha256-T1bZ/TQKeyW3m+IIxJkrEEDKJHGEJBHzJDLsH1Cfoag=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-arm64.tar.gz";
        hash = "sha256-NXpKthOeYYqd9ZVbpXQpNf2O4aC/X9R/kSzoNzDTC7c=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-x64.tar.gz";
        hash = "sha256-ovx+ZBR3ZDDb/HJ464lmhro6kd4OK8jbCSbYJgwubhU=";
=======
        hash = "sha256-h0rA7pCHm9DtD7/ZO4XsCscvKh/wq9vWwcM2KeloSqc=";
      };
      x86_64-darwin = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-macos-x64.tar.gz";
        hash = "sha256-FQXzmLvX4Ac4RtObLVRjeMNW2CYowh8Eq87mH2S9+WA=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-arm64.tar.gz";
        hash = "sha256-Cb25GhImYPhfT/VbY4gFFU1PUEj87z1qi0dlkvFiT/8=";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/unisonweb/unison/releases/download/release/${finalAttrs.version}/ucm-linux-x64.tar.gz";
        hash = "sha256-XutiYr0x4PT4SVADun8ymJpPgX8a4aEqVhD2EqikRkU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];
<<<<<<< HEAD
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
=======
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
