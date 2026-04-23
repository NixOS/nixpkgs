{
  lib,
  stdenv,
  curl,
  xvfb-run,
  the-dark-mod,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "the-dark-mod-assets";
  inherit (the-dark-mod) version;

  nativeBuildInputs = [
    curl
    xvfb-run # The installer needs an X11 environment even when unattended
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    mkdir build
    cd build

    # The installer *really* wants to live in a writable directory to dump its files in
    cp ${lib.getExe the-dark-mod.installer} ./installer

    while true; do
        code=0
        xvfb-run ./installer \
          --unattended \
          --version "release${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}" \
          || code=$?

        case $code in
            0) break ;;
            18) echo "spurious network error; retrying"; continue ;;
            *) echo "error: failed to install game assets"; exit $code ;;
        esac
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Filter out files:
    # * That aren't decidedly reproducible (logs, tmpfiles, any installer manifests),
    # * That we want to build ourselves (executables)
    # * That we want to replace with our own (darkmod.ini)
    find . \
        ! -name "*.log" \
        ! -path "./.zipsync/*" \
        ! -name "*.iniz" \
        ! \( -name "*.exe" -o -executable \) \
        ! -name "darkmod.ini" \
        -exec install -Dm644 {} $out/{} \;

    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-W2BzvKCqoIQYCT/U2Jks1ZtewVSo/ucevR67pnqZTvA=";

  meta = {
    inherit (the-dark-mod.meta) homepage changelog maintainers;
    description = "Assets for the Dark Mod";
    license = with lib.licenses; [ cc-by-nc-sa-30 ];
    platforms = lib.platforms.all;
  };
})
