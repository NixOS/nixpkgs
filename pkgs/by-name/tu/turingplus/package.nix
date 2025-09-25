{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  bootstrap ? callPackage ./bootstrap.nix { },
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "turingplus";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "CordyJ";
    repo = "Open-TuringPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jiMbSuNg2o9fNCPNoLpyAdMCxgMVBiDjRhC0HgKwmqk=";
  };

  nativeBuildInputs = [
    bootstrap
  ];

  # Patch required to fix compilation errors when certain C input files are used with tpc
  patches = [ ./use-gnu89.patch ];

  postPatch = ''
    # Replace hardcoded paths in source
    find src -type f -exec sed -i \
      -e "s#/usr/local/lib/tplus#$out/lib#g" \
      -e "s#/local/lib/tplus#$out/lib#g" \
      -e "s#/usr/local/include/tplus#$out/include#g" \
      -e "s#/local/include/tplus#$out/include#g" \
      -e "s#/usr/local/bin#$out/bin#g" \
      -e "s#/bin/rm#rm#g" \
      {} +
  '';

  buildPhase = ''
    runHook preBuild

    make INCLUDE_DIR=${bootstrap}/include TPC=${bootstrap}/bin/tpc

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    cd test
    make
    cd -

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib,include}
    cp bin/* $out/bin/
    cp lib/* $out/lib/
    cp -r include/* $out/include/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Extended version of the Turing programming language with concurrency and systems programming features";
    mainProgram = "tpc";
    platforms = [ "x86_64-linux" ];
    homepage = "https://github.com/CordyJ/Open-TuringPlus";
    downloadPage = "https://github.com/CordyJ/Open-TuringPlus/releases";
    changelog = "https://github.com/CordyJ/Open-TuringPlus/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ fromSource ];
    maintainers = with maintainers; [ MysteryBlokHed ];
  };
})
