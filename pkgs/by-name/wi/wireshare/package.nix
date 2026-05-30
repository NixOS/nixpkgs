{
  lib,
  stdenv,
  fetchurl,
  jdk21,
  gradle,
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
    sha256 = "19rgqx0i8csz8sadwhv3f7mc6gknbmw2n0xxv4dgymy1zwc7rjzk";
  };

  mitmCache = depsLock;

  nativeBuildInputs = [
    gradle
    jdk21
  ];

  preBuild = ''
    mkdir -p .nix-external-src/{frostwire-jlibtorrent,Smack,guice,cybergarage-upnp}
    tar -xzf ${frostwireJlibtorrentSrc} --strip-components=1 -C .nix-external-src/frostwire-jlibtorrent
    tar -xzf ${smackSrc} --strip-components=1 -C .nix-external-src/Smack
    tar -xzf ${guiceSrc} --strip-components=1 -C .nix-external-src/guice
    tar -xzf ${cybergarageUpnpSrc} --strip-components=1 -C .nix-external-src/cybergarage-upnp
  '';

  buildPhase = ''
    # Nixpkgs' Gradle wrapper replays deps.json through a local proxy instead of
    # relying on ambient caches, so Gradle still resolves the same URLs without
    # talking to the public network during the real build.
    runHook preBuild

    export JAVA_HOME=${jdk21}
    gradle \
      -Dorg.gradle.java.home=${jdk21} \
      -PfrostwireJlibtorrentDir="$PWD/.nix-external-src/frostwire-jlibtorrent" \
      -PsmackDir="$PWD/.nix-external-src/Smack" \
      -PguiceDir="$PWD/.nix-external-src/guice" \
      -PcybergarageUpnpDir="$PWD/.nix-external-src/cybergarage-upnp" \
      wireShareJar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/wireshare
    install -m755 packaging/common/launchers/WireShare $out/bin/WireShare
    install -m644 WireShare.jar $out/share/wireshare/WireShare.jar
    install -Dm644 packaging/common/app/cx.hermes.WireShare.desktop $out/share/applications/cx.hermes.WireShare.desktop
    install -Dm644 packaging/common/app/cx.hermes.WireShare.metainfo.xml $out/share/metainfo/cx.hermes.WireShare.metainfo.xml
    cp -a packaging/common/icons $out/share/

    runHook postInstall
  '';

  passthru = {
    updateDeps = depsLock.updateScript;
  };

  meta = with lib; {
    description = "Peer-to-peer sharing for Gnutella, BitTorrent, magnet, and eD2k";
    homepage = "https://github.com/nmatavka/hermes-wireshare";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "WireShare";
  };
}
