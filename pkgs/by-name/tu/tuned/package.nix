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
  kmod,
  nix-update-script,
  nixosTests,
  pkg-config,
  powertop,
  python3Packages,
  tuna,
  util-linux,
  versionCheckHook,
  virt-what,
  wirelesstools,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuned";
  version = "2.26.0";

  outputs = [
    "out"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "redhat-performance";
    repo = "tuned";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tqr8o4rRhN75hXCdsIhFedfWvicmlIFuZjBNKLQgimQ=";
  };

  patches = [
    # Some tests require a TTY to run
    ./remove-tty-tests.patch
  ];

  postPatch = ''
    patchShebangs .

    substituteInPlace tuned-gui.py tuned.service tuned/ppd/tuned-ppd.service \
      --replace-fail "/usr/sbin/" "$out/bin/"

    substituteInPlace tuned-gui.desktop \
      --replace-fail "/usr/sbin/tuned-gui" "tuned-gui"

    substituteInPlace experiments/powertop2tuned.py \
      --replace-fail "/usr/sbin/powertop" "${lib.getExe powertop}"

    substituteInPlace \
      tuned/{gtk/tuned_dialog.py,consts.py} tuned-gui.py tuned-adm.bash \
      $(find profiles/ -type f -executable -name '*.sh') \
      --replace-warn "/usr/share" "$out/share" \
      --replace-warn "/usr/lib" "$out/lib"
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
    "DESTDIR=${placeholder "out"}"
    "PREFIX="

    "PYTHON=${lib.getExe python3Packages.python}"
    "PYTHON_SITELIB=/${python3Packages.python.sitePackages}"
    "TMPFILESDIR=/lib/tmpfiles.d"
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
      kmod
      util-linux
      virt-what
      wirelesstools
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
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      nixos = nixosTests.tuned;
    };
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
