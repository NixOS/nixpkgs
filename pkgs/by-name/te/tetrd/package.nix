{
  stdenv,
  lib,
  fetchurl,
  writeShellApplication,
  autoPatchelfHook,
  makeWrapper,
  c-ares,
  ffmpeg,
  libevent,
  libvpx,
  libxslt,
  libxtst,
  libxscrnsaver,
  libxdamage,
  minizip,
  nss,
  re2,
  snappy,
  libnotify,
  libappindicator,
  udev,
  libgbm,
  libGL,
  coreutils,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tetrd";
  version = "1.3.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20260718025953/https://download.tetrd.app/files/tetrd.linux_amd64.pkg.tar.xz";
    hash = "sha256-hn3p+iUF7JYQ+TFGbJqvqwDvzgoCfc5SduBgtAExHS0=";
  };

  sourceRoot = ".";
  dontConfigure = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    c-ares
    ffmpeg
    libevent
    libvpx
    libxslt
    libxtst
    libxscrnsaver
    libxdamage
    minizip
    nss
    re2
    snappy
    libnotify
    libappindicator
    udev
    libgbm
    libGL
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p opt/Tetrd/bin
    $CC -O2 -Wall -Wextra -o opt/Tetrd/bin/lnsock ${./lnsock.c}
    runHook postBuild
  '';

  installPhase =
    let
      # Scrapes GUI logs for /run/tetrd-*.sock and links them to the service.
      # Needs services.tetrd.enable (security.wrappers.tetrd-lnsock).
      appWrapper = writeShellApplication {
        name = "tetrd-app-wrapper";
        runtimeInputs = [ coreutils ];
        text = ''
          LNSOCK=/run/wrappers/bin/tetrd-lnsock
          TETRD="''${TETRD:?TETRD must be set by the outer wrapper}"

          if [[ ! -e $LNSOCK ]]; then
            echo "tetrd: enable services.tetrd.enable for the socket linker" >&2
            exit 1
          fi

          trap '"$LNSOCK" --cleanup || true' EXIT

          # Link only the first path the app prints this run.
          created=false
          set +e
          stdbuf -oL -eL "$TETRD" "$@" 2>&1 | while IFS= read -r line || [[ -n $line ]]; do
            printf '%s\n' "$line"
            if ! $created && [[ $line =~ (/run/tetrd-[0-9a-f]+\.sock) ]]; then
              target="''${BASH_REMATCH[1]}"
              echo "tetrd: linking $target → /run/tetrd/run/tetrd.sock" >&2
              "$LNSOCK" "$target" && created=true
            fi
          done
          status=''${PIPESTATUS[0]}
          set -e
          exit "$status"
        '';
      };
    in
    ''
      runHook preInstall

      mkdir -p $out/bin
      cp -a opt $out
      cp -a usr/share $out

      ln -s /var/lib/Tetrd/config.toml $out/opt/Tetrd/bin/config.toml
      ln -s /var/lib/Tetrd/devices.json $out/opt/Tetrd/bin/devices.json

      mv $out/opt/Tetrd/tetrd $out/opt/Tetrd/.tetrd-wrapped
      makeWrapper ${lib.getExe appWrapper} $out/opt/Tetrd/tetrd \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
        --set TETRD $out/opt/Tetrd/.tetrd-wrapped

      ln -s $out/opt/Tetrd/tetrd $out/bin/tetrd-app
      ln -s $out/bin/tetrd-app $out/bin/tetrd
      ln -s $out/opt/Tetrd/bin/tetrd $out/bin/tetrd-service

      runHook postInstall
    '';

  postFixup = ''
    substituteInPlace $out/share/applications/tetrd.desktop \
      --replace-fail /opt/Tetrd/tetrd $out/bin/tetrd
  '';

  passthru.tests = { inherit (nixosTests) tetrd; };

  meta = {
    description = "USB tethering and reverse-tethering";
    longDescription = ''
      USB tethering and reverse-tethering between a PC and a mobile device.

      Enable `services.tetrd.enable` so the GUI can talk to the daemon (socket
      linker under `/run/wrappers`) and so USB access and optional resolvconf
      DNS integration are set up. Prefer that over the app's "run at startup"
      toggle, which does not work with the service's dynamic user account.
    '';
    homepage = "https://tetrd.app";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tetrd";
  };
})
