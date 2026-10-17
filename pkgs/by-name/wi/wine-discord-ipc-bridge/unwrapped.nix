{
  lib,
  stdenv,
  fetchFromGitHub,
  darwinSupport ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wine-discord-ipc-bridge";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "0e4ef622";
    repo = "wine-discord-ipc-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jzsbOKMakNQ6RNMlioX088fGzFBDxOP45Atlsfm2RKg=";
  };

  patches = lib.optional darwinSupport ./darwinSupport.patch;

  postPatch = ''
    patchShebangs winediscordipcbridge-steam.sh
  ''
    # darwin patch replaces l_getenv with a windows getenv; make sure
    # we're looking up tmp on the unix host, not windows
  + lib.optionalString darwinSupport ''
    substituteInPlace main.c --replace-fail '"TMPDIR"' '"WINE_HOST_TMPDIR"' \
                             --replace-fail '"TMP"' '"WINE_HOST_TMP"' \
                             --replace-fail '"TEMP"' '"WINE_HOST_TEMP"'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp winediscordipcbridge.exe $out/bin
    cp winediscordipcbridge-steam.sh $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Enable games running under wine to use Discord Rich Presence";
    homepage = "https://github.com/0e4ef622/wine-discord-ipc-bridge";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.uku3lig ];
    mainProgram = "winediscordipcbridge";
    platforms = if darwinSupport then [ "x86_64-windows" ] else [ "i686-windows" ];
  };
})
