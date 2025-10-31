{
  lib,
  stdenv,
  temurin-bin,
  openjfx,

  autoPatchelfHook,
}:
stdenv.mkDerivation {
  pname = "temurin-jfx-bin";
  inherit (temurin-bin) version;

  dontUnpack = true;

  buildInputs = [ temurin-bin ];
  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    jfxDir="${openjfx}/jmods"
    jdkDir="${temurin-bin}/jmods"
    jmods="$(find "$jdkDir" "$jfxDir" -maxdepth 1 -type f -printf '%f\n' | sed 's/\.jmod$//' | tr '\n' ',')"

    jlink \
      --module-path "$jdkDir":"$jfxDir" \
      --add-modules "$jmods" \
      --output $out

    mkdir -p $out/jmods
    cp -r "$jfxDir"/* "$jdkDir"/* $out/jmods
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    [ "$($out/bin/jshell -s \
      <<< 'import javafx.application.*;' 2>&1 \
      | grep -Eic 'error|does not exist')" == 0 ]

    runHook postInstallCheck
  '';

  meta = {
    description = "Temurin with JavaFX support patched in";
    license = with lib.licenses; [
      gpl2
      classpathException20
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # prebuilt java binaries
      binaryBytecode # linked classes
      fromSource # openjfx code
    ];
    # No jmods available since JEP 493
    broken = lib.versionAtLeast temurin-bin.version "24";
  };
}
