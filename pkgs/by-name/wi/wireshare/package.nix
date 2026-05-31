{
  lib,
  stdenv,
  fetchurl,
  gitMinimal,
  jdk21,
  gradle,
  makeWrapper,
}:

let
  mkPinnedGitHubTarball =
    {
      owner,
      repo,
      rev,
      hash,
    }:
    fetchurl {
      url = "https://codeload.github.com/${owner}/${repo}/tar.gz/${rev}";
      inherit hash;
    };

  frostwireJlibtorrentRev = "e71a7ee23cb22f8e1db23b3e49108d3de8097710";
  frostwireJlibtorrentSrc = mkPinnedGitHubTarball {
    owner = "frostwire";
    repo = "frostwire-jlibtorrent";
    rev = frostwireJlibtorrentRev;
    hash = "sha256-j2LpGAeozy9WatR04S5mkStgkzfBT09hpSPdVbKlli0=";
  };

  smackRev = "25655f86911573615e1671210c2f81162699a602";
  smackSrc = mkPinnedGitHubTarball {
    owner = "igniterealtime";
    repo = "Smack";
    rev = smackRev;
    hash = "sha256-F0zsgS9aQVBTe4Ch2EiW4X74cujKY/fEwtn6uZobKlw=";
  };

  guiceRev = "55a2b68ebe445b8dca3795bd3cdfc5c09d566e74";
  guiceSrc = mkPinnedGitHubTarball {
    owner = "google";
    repo = "guice";
    rev = guiceRev;
    hash = "sha256-pbNoM72TEL62Uhuetc1tQsnhNATMMm4GpwbCudD+3m0=";
  };

  cybergarageUpnpRev = "f4a1ada0188cd5f8afc13391c8346b3ef5eaed50";
  cybergarageUpnpSrc = mkPinnedGitHubTarball {
    owner = "cybergarage";
    repo = "cybergarage-upnp";
    rev = cybergarageUpnpRev;
    hash = "sha256-Q08vD+lkW/m5/DpRmfnK3fYs0y8QRhdE1F5NmP6yL2M=";
  };

  depsLock = gradle.fetchDeps {
    pname = "wireshare";
    data = ./deps.json;
  };
in
stdenv.mkDerivation {
  pname = "wireshare";
  version = "7.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/nmatavka/hermes-wireshare/releases/download/release/7.0/WireShare-7.0-source.tar.gz";
    sha256 = "1wybghcgzhapzwddkg835dw5sxiyqgm72qs3vsa4cprk2i0wfbx7";
  };

  mitmCache = depsLock;

  nativeBuildInputs = [
    gitMinimal
    gradle
    jdk21
    makeWrapper
  ];

  postPatch = ''
        # Older 7.0 source tarballs wire wireShareJar to the desktop classes task
        # via an eager lookup. Backport the lazier output-based dependency when
        # that legacy line is still present.
        if grep -Fq "    dependsOn desktopComposeAppProject.tasks.named('classes')" build.gradle; then
          substituteInPlace build.gradle \
            --replace-fail \
            "    dependsOn desktopComposeAppProject.tasks.named('classes')" \
            "    dependsOn desktopComposeMainOutput"
        fi

        mac_bridge=desktop-compose-app/src/main/java/org/limewire/ui/compose/integration/MacUserNotificationBridge.java
        if ! grep -Fq 'WIRESHARE_DISABLE_MAC_NOTIFICATIONS' "$mac_bridge"; then
          mac_disabled_replacement="$(cat <<'EOF'
        private static final boolean DISABLED =
                "1".equals(System.getenv("WIRESHARE_DISABLE_MAC_NOTIFICATIONS")) ||
                Boolean.getBoolean("wireshare.macNotifications.disable");
        private static final AtomicLong IDS = new AtomicLong();
    EOF
    )"
          substituteInPlace "$mac_bridge" \
            --replace-fail \
            "    private static final AtomicLong IDS = new AtomicLong();" \
            "$mac_disabled_replacement"
          substituteInPlace "$mac_bridge" \
            --replace-fail \
            "    private static final boolean LOADED = NativeLibraryLoader.loadFirstAvailable(" \
            "    private static final boolean LOADED = !DISABLED && NativeLibraryLoader.loadFirstAvailable("
        fi
  '';

  preBuild = ''
    mkdir -p .nix-external-src/{frostwire-jlibtorrent,Smack,guice,cybergarage-upnp}
    tar -xzf ${frostwireJlibtorrentSrc} --strip-components=1 -C .nix-external-src/frostwire-jlibtorrent
    tar -xzf ${smackSrc} --strip-components=1 -C .nix-external-src/Smack
    tar -xzf ${guiceSrc} --strip-components=1 -C .nix-external-src/guice
    tar -xzf ${cybergarageUpnpSrc} --strip-components=1 -C .nix-external-src/cybergarage-upnp
    export JAVA_HOME=${jdk21}
    gradleFlagsArray+=(
      -Dorg.gradle.java.home=${jdk21}
      -PfrostwireJlibtorrentDir="$PWD/.nix-external-src/frostwire-jlibtorrent"
      -PsmackDir="$PWD/.nix-external-src/Smack"
      -PguiceDir="$PWD/.nix-external-src/guice"
      -PcybergarageUpnpDir="$PWD/.nix-external-src/cybergarage-upnp"
    )
  '';

  buildPhase = ''
    # Nixpkgs' Gradle wrapper replays deps.json through a local proxy instead of
    # relying on ambient caches, so Gradle still resolves the same URLs without
    # talking to the public network during the real build.
    runHook preBuild

    gradle wireShareJar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/libexec $out/share/wireshare
    cat > $out/libexec/WireShare <<'EOF'
    #!/usr/bin/env sh
    set -eu

    JAVA_BIN="''${JAVA:-java}"
    APP_ROOT="''${WIRESHARE_APP_ROOT:?}"
    LIB_ROOT="''${WIRESHARE_LIB_ROOT:?}"

    exec "''${JAVA_BIN}" -Djava.library.path="''${LIB_ROOT}" -jar "''${APP_ROOT}/WireShare.jar" "$@"
    EOF
    chmod 755 $out/libexec/WireShare
    install -m644 WireShare.jar $out/share/wireshare/WireShare.jar
    install -Dm644 packaging/common/app/cx.hermes.WireShare.desktop $out/share/applications/cx.hermes.WireShare.desktop
    install -Dm644 packaging/common/app/cx.hermes.WireShare.metainfo.xml $out/share/metainfo/cx.hermes.WireShare.metainfo.xml
    cp -a packaging/common/icons $out/share/

    makeWrapperArgs=(
      --set-default JAVA ${jdk21}/bin/java
      --set-default WIRESHARE_APP_ROOT $out/share/wireshare
      --set-default WIRESHARE_LIB_ROOT $out/share/wireshare
    )
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # macOS' UserNotifications bridge assumes an app-bundle launch context.
    # The Nix package runs as a plain Java process, so disable that bridge and
    # let WireShare fall back instead of aborting during startup.
    makeWrapperArgs+=(--set-default WIRESHARE_DISABLE_MAC_NOTIFICATIONS 1)
  ''
  + ''
    makeWrapper $out/libexec/WireShare $out/bin/WireShare "''${makeWrapperArgs[@]}"

    runHook postInstall
  '';

  passthru = {
    updateDeps = depsLock.updateScript;
  };

  meta = with lib; {
    description = "Peer-to-peer sharing for Gnutella, BitTorrent, magnet, and eD2k";
    homepage = "https://github.com/nmatavka/hermes-wireshare";
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nmatavka ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "WireShare";
  };
}
