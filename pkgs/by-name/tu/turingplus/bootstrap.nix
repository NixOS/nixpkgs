{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  coreutils,
  libredirect,
}:
let
  sources = {
    "x86_64-linux" = {
      url = "https://github.com/CordyJ/Open-TuringPlus/releases/download/v6.2.1/opentplus-62-linux64.tar.gz";
      sha256 = "sha256-FoOlOcRWpStg4aerjr+FmcXXnwYftrqG1j4iZJ+4AzE=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/CordyJ/Open-TuringPlus/releases/download/v6.2.1/opentplus-62-macos64.tar.gz";
      sha256 = "sha256-8o1hIA74JPqZyjWfg4leC99z1+YMVhwFGME5qBf/BP0=";
    };
  };

  redirects = [
    # Turing+ library/includes
    "/usr/local/lib/tplus=${placeholder "out"}/lib"
    "/local/lib/tplus=${placeholder "out"}/lib"
    "/usr/local/include/tplus=${placeholder "out"}/include"
    "/local/include/tplus=${placeholder "out"}/include"
    # Turing+ binaries
    "/usr/local/bin=${placeholder "out"}/bin"
    # Other
    "/bin/rm=${coreutils}/bin/rm"
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "turingplus-bootstrap";
  version = "6.2.1";

  src = fetchzip sources."${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,include}
    cp bin/* $out/bin/
    cp lib/* $out/lib/
    cp -r include/* $out/include/

    runHook postInstall
  '';

  # Wrap package and redirect FHS reads to the derivation output
  postInstall =
    let
      preloadVar = if stdenv.hostPlatform.isDarwin then "DYLD_INSERT_LIBRARIES" else "LD_PRELOAD";
      preloadLib = "${libredirect}/lib/libredirect" + stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      wrapProgram $out/bin/tpc \
        --set ${preloadVar} ${preloadLib} \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set NIX_ENFORCE_PURITY 0

      wrapProgram $out/bin/tssl \
        --set ${preloadVar} ${preloadLib} \
        --set NIX_REDIRECTS ${builtins.concatStringsSep ":" redirects} \
        --set NIX_ENFORCE_PURITY 0
    '';

  meta = {
    description = "Extended version of the Turing programming language with concurrency and systems programming features";
    mainProgram = "tpc";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    homepage = "https://github.com/CordyJ/Open-TuringPlus";
    downloadPage = "https://github.com/CordyJ/Open-TuringPlus/releases";
    changelog = "https://github.com/CordyJ/Open-TuringPlus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
