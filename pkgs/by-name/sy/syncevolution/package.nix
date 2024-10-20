{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  autoconf,
  automake,
  autoreconfHook,
  bash,
  boost,
  bluez,
  coreutils,
  cppunit,
  curl,
  dbus-glib,
  dbus-test-runner,
  docutils,
  evolution-data-server,
  expat,
  glib,
  gtk3,
  intltool,
  json_c,
  libaccounts-glib,
  libical,
  libnotify,
  libsecret,
  libsignon-glib,
  libtool,
  libxslt,
  neon,
  openobex,
  pcre,
  perl,
  pkg-config,
  python3,
  sqlite,
  valgrind,
  xmlrpc_c,

  libsForQt5,
  qtPackages ? libsForQt5,
}:

let
  synthesis-src = stdenv.mkDerivation (finalAttrs: {
    pname = "libsynthesis";
    # tagging scheme is bonkers, take only the bit of the versioning that makes sense
    version = "3.4.0.47-unstable-2021-02-06";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "SyncEvolution";
      repo = "libsynthesis";
      rev = "43191b6c05cd7f7342e4e16ae8f8063d126a99e3";
      hash = "sha256-zYfLjTXJzt5yz+dJzegbRAVaad7kZ6PtNVRlYk97ZxE=";
    };

    strictDeps = true;

    nativeBuildInputs = [
      autoconf
      automake
      libtool
      pkg-config
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      ./autogen.sh

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R . $out

      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "syncevolution";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "SyncEvolution";
    repo = "syncevolution";
    rev = "refs/tags/syncevolution-${lib.strings.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-f9FMeNyEA4kH7DaTyRXiXAiykGudjohyNfKaARaGrIc=";
  };

  patches = [
    # Remove when version > 2.0.0
    (fetchpatch {
      name = "0001-syncevolution-fix-maemo.patch";
      url = "https://gitlab.freedesktop.org/SyncEvolution/syncevolution/-/commit/0824c3cd64499aaa5c2d63ab797951b8f492072a.patch";
      hash = "sha256-sBfN28NkF2f4zx/tDRjc6LNKcUGWeg8+anh7Exsz/sc=";
    })

    # Remove when https://gitlab.freedesktop.org/SyncEvolution/syncevolution/-/merge_requests/2 merged & in release
    (fetchpatch {
      name = "0002-syncevolution-fix-qt-dbus-bindings.patch";
      url = "https://gitlab.freedesktop.org/SyncEvolution/syncevolution/-/commit/9d9535b65e7765aa8073d8153c44668dda2182bc.patch";
      hash = "sha256-R+ZO0uMZ1j5HOiqM2UNU58bzyvtItAG+AYXMgUqxA7o=";
    })
  ];

  postPatch = ''
    # IT_PROG_INTLTOOL needs to be at start of line for (insert tool name here) to find it & not error out
    # Use pkg-config where possible
    substituteInPlace configure.ac \
      --replace-fail '    IT_PROG_INTLTOOL(' 'IT_PROG_INTLTOOL(' \
      --replace-fail 'curl-config' "$PKG_CONFIG libcurl"

    # Was renamed in v1->v2 transition
    substituteInPlace src/backends/signon/{signon,signon-accounts,signonRegister}.cpp \
      --replace-fail 'signon_auth_session_process_async' 'signon_auth_session_process'

    substituteInPlace src/syncevo/ForkExec.cpp \
      --replace-fail '/bin/true' '${lib.getExe' coreutils "true"}'

    substituteInPlace src/syncevo/ForkExec.cpp test/dbus-client-server.cpp \
      --replace-fail '/bin/false' '${lib.getExe' coreutils "false"}'
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      autoreconfHook
      dbus-glib # dbus-binding-tool
      docutils
      glib # AM_GLIB_GNU_GETTEXT, glib-genmarshal
      intltool
      libxslt
      pkg-config
      (python3.withPackages (ps: with ps; [ pygments ]))
      xmlrpc_c # xmlrpc-c-config
    ]
    ++ lib.optionals (qtPackages != null) [
      qtPackages.qtbase # qdbusxml2cpp
    ];

  buildInputs = [
    bash
    boost
    bluez
    curl
    dbus-glib
    evolution-data-server
    expat
    glib
    gtk3
    json_c
    libaccounts-glib
    libical
    libnotify
    libsecret
    libsignon-glib
    neon
    openobex
    pcre
    perl
    (python3.withPackages (
      ps: with ps; [
        twisted
        urllib3
      ]
    ))
    sqlite
    valgrind
    xmlrpc_c
  ];

  nativeCheckInputs = [ dbus-test-runner ];

  checkInputs = [ cppunit ];

  dontWrapQtApps = true;

  configureFlags = [
    (lib.strings.enableFeature true "bluetooth")
    (lib.strings.enableFeature true "libcurl")
    (lib.strings.enableFeature false "libsoup") # already have curl
    (lib.strings.enableFeature false "mlite") # SFOS

    (lib.strings.withFeatureAs true "rst2man" (lib.getExe' docutils "rst2man"))
    (lib.strings.withFeatureAs true "rst2html" (lib.getExe' docutils "rst2html"))
    (lib.strings.withFeatureAs true "synthesis-src" synthesis-src)

    (lib.strings.enableFeature true "core")
    (lib.strings.enableFeature false "cmdline") # "No configuration template [...] available" in tests
    (lib.strings.enableFeature true "local-sync")
    (lib.strings.enableFeature true "dbus-service")
    (lib.strings.enableFeatureAs true "gui" "gtk")
    (lib.strings.enableFeature false "gnome-bluetooth-panel-plugin") # bluetooth-plugin.h, maybe gnome-bluetooth v2.x?
    (lib.strings.enableFeature true "doc")
    (lib.strings.enableFeature (qtPackages != null) "qt-dbus")

    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "integration-tests")
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "unit-tests")

    # libsynthesis options
    (lib.strings.enableFeature true "libical")
    (lib.strings.enableFeature true "regex")
    (lib.strings.enableFeature true "sqlite")
    (lib.strings.withFeature false "xmltok")
    (lib.strings.withFeatureAs true "expat" "system")

    # Backends
    (lib.strings.enableFeature true "dav")
    (lib.strings.enableFeature true "ebook")
    (lib.strings.enableFeature true "ecal")
    (lib.strings.enableFeature true "file")
    (lib.strings.enableFeature true "gnome-keyring")
    (lib.strings.enableFeature true "goa")
    (lib.strings.enableFeature true "oauth2")
    (lib.strings.enableFeature true "pbap")
    (lib.strings.enableFeature true "signon")
    (lib.strings.enableFeature true "uoa")
    (lib.strings.enableFeature true "xmlrpc")

    (lib.strings.enableFeature false "gsso") # needs libgsignon-glib
    (lib.strings.enableFeature false "kwallet") # KDE4
    (lib.strings.enableFeature false "tdewallet") # TDE
    (lib.strings.enableFeature false "tdepimcal") # TDE
    (lib.strings.enableFeature false "tdepimabc") # TDE
    (lib.strings.enableFeature false "tdepimnotes") # TDE
  ];

  # Not parallel-safe when building tests, solibs get regenerated while attempting to link against them
  enableParallelBuilding = finalAttrs.doCheck;

  # Failures due to not finding its templates & ambiguous backend names
  doCheck = false;

  checkPhase = ''
    runHook preInstallCheck

    export HOME=$TMP
    cd test
    dbus-test-runner --max-wait 120 --task $PWD/../src/client-test

    runHook postInstallCheck
  '';

  meta = {
    description = "Synchronizes personal information management (PIM) data";
    homepage = "https://syncevolution.org";
    license = with lib.licenses; [
      artistic1
      # TODO add to licenses.nix
      (rec {
        shortName = "FSFAP";
        fullName = "FSF All Permissive License";
        spdxId = "FSFAP";
        url = "https://spdx.org/licenses/${spdxId}.html";
        free = true;
        deprecated = false;
        redistributable = free;
      })
      gpl1Plus
      gpl2Plus
      gpl3Only
      lgpl2Only
      lgpl2Plus
      lgpl21Only
      lgpl3Only
      mit
    ];
  };
})
