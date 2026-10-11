{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  autoreconfHook,
  pkg-config,
  m4,
  curl,
  json_c,
  systemd,
  nixosTests,
  runtimeShell,
  withJournal ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tlog";
  version = "14";

  src = fetchFromGitHub {
    owner = "Scribery";
    repo = "tlog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OYkYpoJ8TGWlRcBDxCnaNewjDJ6YZwC73lSC5PLH0I4=";
  };

  patches = [
    # GCC 15 defaults to C23, where `f()` means `f(void)`, so the SIGCHLD
    # handler no longer matches sa_handler. Fixed on master after v14.
    (fetchpatch2 {
      name = "add-missing-argument-for-sigchld-handler.patch";
      url = "https://github.com/Scribery/tlog/commit/de6cd0172e1a6603ae04767b96260b1b47b458d1.patch?full_index=1";
      hash = "sha256-g+s2HfWbpkaDMiIIX/3GkGc4QsT4J6/RskDDkh1RraM=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    # configure.ac hard-requires m4 on PATH; it also generates the config files.
    m4
  ];

  buildInputs = [
    curl
    json_c
  ]
  # Not systemdLibs: it is built without compression support and silently
  # skips the (compressed) journal files when reading, so tlog-play -r journal
  # would find nothing. Writing works with either.
  ++ lib.optional withJournal systemd;

  configureFlags = [
    # The binaries compile in these paths: system-wide config under /etc/tlog
    # and the session lock dir under /var/run/tlog. They must point at the
    # running system, not the store.
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (lib.enableFeature withJournal "journal")
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
      -- ${runtimeShell} -c 'echo hello-tlog' </dev/null
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

  passthru.tests.nixos = nixosTests.tlog.extendNixOS {
    module.programs.tlog.package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Terminal I/O recording and playback package suitable for logging to journald and Elasticsearch";
    longDescription = ''
      tlog records terminal sessions (by default to the systemd journal) and
      replays them with tlog-play. Typically tlog-rec-session is used as the
      login shell of users whose sessions should be audited.

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
