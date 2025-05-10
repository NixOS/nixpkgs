{
  lib,
  asciidoctor,
  desktop-file-utils,
  dmidecode,
  ethtool,
  fetchFromGitHub,
  gawk,
  gobject-introspection,
  hdparm,
  iproute2,
  nix-update-script,
  pkg-config,
  powertop,
  python3,
  testers,
  tuna,
  tuned,
  util-linux,
  virt-what,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tuned";
  version = "2.24.0";
  pyproject = false;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "redhat-performance";
    repo = "tuned";
    rev = "refs/tags/v${version}";
    hash = "sha256-6x5sRzHZEKS7keEBRqDNQsdAcqrpsZ4h2eTCi1o0hPM=";
  };

  patches = [
    # Some tests require a TTY to run
    ./remove-tty-tests.patch
  ];

  postPatch = ''
    patchShebangs .

    substituteInPlace Makefile \
      --replace-warn "/usr/bin/powertop2tuned" "/bin/powertop2tuned" \
      --replace-warn "/usr/lib" "/lib" \
      --replace-warn "/usr/sbin" "/bin"

    substituteInPlace tuned-gui.desktop \
      --replace-warn "/usr/sbin/tuned-gui" "tuned-gui"

    substituteInPlace tuned.service \
      --replace-warn "/usr/sbin/tuned" "$out/bin/tuned"

    substituteInPlace experiments/powertop2tuned.py \
      --replace-warn "/usr/sbin/powertop" "${lib.getExe powertop}"

    substituteInPlace tuned/ppd/tuned-ppd.service \
      --replace-warn "/usr/sbin/tuned-ppd" "$out/bin/tuned-ppd"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    desktop-file-utils
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  dependencies = with python3.pkgs; [
    dbus-python
    pygobject3
    pyperf
    python-linux-procfs
    pyudev
    tuna
  ];

  makeFlags = [
    "DATADIR=/share"
    "DESTDIR=${placeholder "out"}"
    "KERNELINSTALLHOOKDIR=/lib/kernel/install.d"
    "PYTHON=${lib.getExe python3}"
    "PYTHON_SITELIB=/${python3.sitePackages}"
    "TMPFILESDIR=/lib/tmpfiles.d"
    "TUNED_PROFILESDIR=/lib/tuned/profile"
    "UNITDIR=/lib/systemd/system"
  ];

  installTargets = [
    "install"
    "install-ppd"
  ];

  postInstall = ''
    rm -rf $out/{var,run}
  '';

  dontWrapGApps = true;
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      dmidecode
      ethtool
      gawk
      hdparm
      iproute2
      util-linux
      virt-what
    ])
  ];

  checkTarget = "test";

  pythonImportsCheck = [ "tuned" ];

  # NOTE: `postCheck` is intentionally not used here, as the entire checkPhase
  # is skipped by `buildPythonApplication`
  # https://github.com/NixOS/nixpkgs/blob/9d4343b7b27a3e6f08fc22ead568233ff24bbbde/pkgs/development/interpreters/python/mk-python-derivation.nix#L296
  postInstallCheck = ''
    make $makeFlags $checkTarget
  '';

  passthru = {
    tests.version = testers.testVersion { package = tuned; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tuning Profile Delivery Mechanism for Linux";
    homepage = "https://tuned-project.org";
    changelog = "https://github.com/redhat-performance/tuned/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "tuned";
    platforms = lib.platforms.linux;
  };
}
