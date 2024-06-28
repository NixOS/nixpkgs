{
  lib,
  stdenv,
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
  python3Packages,
  tuna,
  util-linux,
  versionCheckHook,
  virt-what,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuned";
  version = "2.25.1";

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "redhat-performance";
    repo = "tuned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MMyYMgdvoAIeLCqUZMoQYsYYbgkXku47nZWq2aowPFg=";
  };

  patches = [
    # Some tests require a TTY to run
    ./remove-tty-tests.patch
  ];

  postPatch = ''
    patchShebangs .

    substituteInPlace tuned-gui.py tuned.service tuned/ppd/tuned-ppd.service \
      --replace-warn "/usr/sbin/" "$out/bin/"

    substituteInPlace tuned-gui.py \
      --replace-warn "/usr/share/" "$out/share/"

    substituteInPlace tuned-gui.desktop \
      --replace-warn "/usr/sbin/tuned-gui" "tuned-gui"

    substituteInPlace experiments/powertop2tuned.py \
      --replace-warn "/usr/sbin/powertop" "${lib.getExe powertop}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    asciidoctor
    desktop-file-utils
    gobject-introspection
    pkg-config
    wrapGAppsHook3
    python3Packages.wrapPython
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pygobject3
    pyinotify
    pyperf
    python-linux-procfs
    pyudev
    tuna
  ];

  makeFlags = [
    "PREFIX="

    "DATADIR=/share"
    "DESTDIR=${placeholder "out"}"
    "KERNELINSTALLHOOKDIR=/lib/kernel/install.d"
    "PYTHON=${lib.getExe python3Packages.python}"
    "PYTHON_SITELIB=/${python3Packages.python.sitePackages}"
    "TMPFILESDIR=/lib/tmpfiles.d"
    "TUNED_PROFILESDIR=/lib/tuned/profile"
    "UNITDIR=/lib/systemd/system"
  ];

  installTargets = [
    "install"
    "install-ppd"
  ];

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

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkTarget = "test";

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    python3Packages.pythonImportsCheckHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "tuned" ];

  postInstall = ''
    rm -rf $out/{run,var}
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tuning Profile Delivery Mechanism for Linux";
    homepage = "https://tuned-project.org";
    changelog = "https://github.com/redhat-performance/tuned/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "tuned";
    platforms = lib.platforms.linux;
  };
})
