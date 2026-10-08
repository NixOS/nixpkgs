{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  m4,
  pkg-config,
  curl,
  json_c,
  systemdLibs,
  nix-update-script,
  nixosTests,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlog";
  version = "15";

  src = fetchFromGitHub {
    owner = "Scribery";
    repo = "tlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/0tUpaAJd8qiNe6STOycZJZijfZPWLWf4RjasftVKm4=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    # configure.ac requires it; the Makefiles generate C sources, configs
    # and man pages with it.
    m4
    pkg-config
  ];

  buildInputs = [
    curl
    json_c
  ]
  ++ lib.optional withSystemd systemdLibs;

  configureFlags = [
    # The binaries compile in these paths: system-wide config under /etc/tlog
    # and the session lock dir under /var/run/tlog. They must point at the
    # running system, not the store.
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.enableFeature withSystemd "journal")
  ];

  # Install the system-wide config templates into the store instead of /etc;
  # a NixOS module (or the admin) links them into /etc/tlog.
  installFlags = [ "pkgconflocaldir=${placeholder "out"}/etc/tlog" ];

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  # The binaries refuse to start without /etc/tlog/*.conf, which the sandbox
  # lacks, so versionCheckHook cannot be used. Instead, exploit upstream's
  # build-tree detection: a binary living in a `.libs` dir reads its config
  # from `../`. Copy (not symlink: the lookup uses realpath) the binaries
  # there and do a real record + replay round trip.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    mkdir -p smoke/.libs
    cp $out/bin/tlog-rec $out/bin/tlog-play smoke/.libs/
    cp $out/etc/tlog/tlog-{rec,play}.conf $out/share/tlog/tlog-{rec,play}.default.conf smoke/

    smoke/.libs/tlog-rec --version | grep -F "tlog ${finalAttrs.version}"
    smoke/.libs/tlog-rec --writer=file --file-path=smoke/rec.json \
      -- echo hello-tlog </dev/null
    grep -F hello-tlog smoke/rec.json
    # tlog-play hangs without output when stdin is at EOF (the sandbox gives
    # /dev/null), so hand it a pipe that stays open; timeout guards regressions.
    timeout 60 smoke/.libs/tlog-play --reader=file --file-path=smoke/rec.json \
      < <(sleep 60) | grep -aF hello-tlog

    # The round trip above reads its config via the build-tree fallback, so
    # separately assert the paths the installed library will really use.
    for path in /etc/tlog/tlog-{rec,rec-session,play}.conf \
                $out/share/tlog/tlog-{rec,rec-session,play}.default.conf \
                /var/run/tlog/session.%u.lock; do
      grep -aqF "$path" $out/lib/libtlog.so.0 || { echo "libtlog lacks $path"; exit 1; }
    done

    runHook postInstallCheck
  '';

  passthru.tests.tlog = nixosTests.tlog.extendNixOS {
    module.programs.tlog.package = finalAttrs.finalPackage;
  };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal I/O recorder and player for auditing user sessions";
    longDescription = ''
      tlog records terminal sessions to the systemd journal, syslog or a file,
      and replays them with tlog-play. tlog-rec-session is meant to be the
      login shell of users whose sessions are audited.

      All tlog binaries refuse to start unless their system-wide
      configuration exists in /etc/tlog (tlog-rec.conf, tlog-rec-session.conf
      and tlog-play.conf). On NixOS, enable `programs.tlog`, which provides
      these files and the setuid tlog-rec-session wrapper; elsewhere, create
      them (an empty JSON object `{}` is a valid configuration).
    '';
    homepage = "https://github.com/Scribery/tlog";
    changelog = "https://github.com/Scribery/tlog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ oakenshield ];
    mainProgram = "tlog-rec";
    platforms = lib.platforms.linux;
  };
})
