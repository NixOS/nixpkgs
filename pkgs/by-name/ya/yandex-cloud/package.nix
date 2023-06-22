{ lib
, stdenv
, fetchurl
, makeBinaryWrapper
, installShellFiles
, testers
, buildPackages
, withShellCompletions ? stdenv.hostPlatform.emulatorAvailable buildPackages
  # update script
, writeShellScript
, writers
, python3Packages
, nix
}:
let
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;
  binaries = lib.mapAttrs (_: fetchurl) sources.binaries;
  emulator = stdenv.hostPlatform.emulator buildPackages;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yandex-cloud";
  inherit version;

  src = binaries.${stdenv.hostPlatform.system};

  dontUnpack = true;

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/yc
    chmod +x $out/bin/yc
  '' + lib.optionalString (withShellCompletions) ''
    for shell in bash zsh; do
      ${emulator} $out/bin/yc completion $shell >yc.$shell
      installShellCompletion yc.$shell
    done
  '' + ''
    makeWrapper $out/bin/yc $out/bin/docker-credential-yc \
      --add-flags --no-user-output \
      --add-flags container \
      --add-flags docker-credential

    runHook postInstall
  '';

  passthru = {
    updateScript =
      let
        updater = writers.writePython3 "${finalAttrs.pname}-updater"
          { libraries = with python3Packages; [ requests ]; }
          ./update.py;
      in
      writeShellScript "${finalAttrs.pname}-updateScript" ''
        set -e -u
        PATH=${lib.escapeShellArg (lib.makeBinPath [ nix ])}
        exec ${lib.escapeShellArg updater}
      '';

    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Command line interface that helps you interact with Yandex Cloud services";
    homepage = "https://cloud.yandex/docs/cli";
    changelog = "https://cloud.yandex/docs/cli/release-notes#version${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.tie ];
    platforms = with lib.systems.inspect.patterns; [
      (isDarwin // isAarch64)
      (isDarwin // isx86_64)
      (isLinux // isAarch64)
      (isLinux // isx86_64)
      # Built with GO386=sse2.
      #
      # Unfortunately, we don’t have anything about SSE2 support in lib.systems,
      # so we can’t mark this a broken or bad platform if host platform does not
      # support SSE2. See also https://github.com/NixOS/nixpkgs/issues/132217
      #
      # Perhaps it would be possible to mark it as broken if platform declares
      # GO386=softfloat once https://github.com/NixOS/nixpkgs/pull/256761 is
      # ready and merged.
      (isLinux // isi686)
    ];
    mainProgram = "yc";
  };
})
