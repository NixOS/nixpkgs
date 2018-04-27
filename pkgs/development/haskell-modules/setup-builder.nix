{ stdenv, ghc, mkCompilerEnv }:

{ pname
, version
, src
, setupHaskellDepends
, preCompileBuildDriver ? "", postCompileBuildDriver ? ""
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
}:

let
  inherit (stdenv.lib) concatStringsSep optionalString versionOlder;

  ghcCommand = "${ghc.targetPrefix}ghc";

  isGhcjs = ghc.isGhcjs or false;
  isHaLVM = ghc.isHaLVM or false;

  setupCompileFlags = [
    (optionalString (isGhcjs || isHaLVM || versionOlder "7.8" ghc.version) "-j$NIX_BUILD_CORES")
    # https://github.com/haskell/cabal/issues/2398
    (optionalString (versionOlder "7.10" ghc.version && !isHaLVM) "-threaded")
  ];

  defaultSetupHs = builtins.toFile "Setup.hs" ''
                     import Distribution.Simple
                     main = defaultMain
                   '';
in

stdenv.mkDerivation {
  name = "${pname}-${version}-setup";
  inherit src;

  nativeBuildInputs = [ ghc ];
  buildInputs = setupHaskellDepends;

  inherit preCompileBuildDriver postCompileBuildDriver
          preUnpack postUnpack
          patches patchPhase prePatch postPatch;

  phases = [ "unpackPhase" "patchPhase" "compileBuildDriverPhase" ];

  compileBuildDriverPhase = ''
    echo "Build with ${ghc}."

    runHook preCompileBuildDriver

    ${mkCompilerEnv {
      outDir = "$TMPDIR";
      enableSharedLibraries = false;
    }}
    setupCompileFlags="${concatStringsSep " " setupCompileFlags} $envGhcFlags"

    for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
      test -f $i && break
    done

    echo setupCompileFlags: $setupCompileFlags

    mkdir -p "$out"
    "${ghcCommand}" "$i" $setupCompileFlags --make -o "$out/Setup" -odir "$TMPDIR" -hidir "$TMPDIR"

    runHook postCompileBuildDriver
  '';
}
