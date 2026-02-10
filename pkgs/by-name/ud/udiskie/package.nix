{
  lib,
  asciidoc,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  installShellFiles,
  libappindicator-gtk3,
  libnotify,
  librsvg,
  python3Packages,
  udisks,
  wrapGAppsHook3,
  testers,
  udiskie,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "udiskie";
  version = "2.6.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1/qQS2bAxoHbWWmMkDoV5QNSUVYCQfer6lWM9ptG+Vk=";
  };

  patches = [
    ./locale-path.patch
  ];

  postPatch = ''
    substituteInPlace udiskie/locale.py --subst-var out
  '';

  nativeBuildInputs = [
    asciidoc # Man page
    gobject-introspection
    installShellFiles
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dontWrapGApps = true;

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libnotify
    librsvg # SVG icons
    udisks
  ];

  dependencies = with python3Packages; [
    docopt
    keyutils
    pygobject3
    pyyaml
  ];

  postBuild = ''
    make -C doc
  '';

  postInstall = ''
    installManPage doc/udiskie.8

    installShellCompletion \
      --bash completions/bash/* \
      --zsh completions/zsh/*
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  passthru.tests.version = testers.testVersion {
    package = udiskie;
  };

  meta = {
    homepage = "https://github.com/coldfix/udiskie";
    changelog = "https://github.com/coldfix/udiskie/blob/${finalAttrs.src.tag}/CHANGES.rst";
    description = "Removable disk automounter for udisks";
    longDescription = ''
      udiskie is a udisks2 front-end that allows to manage removeable media such
      as CDs or flash drives from userspace.

      Its features include:
      - automount removable media
      - notifications
      - tray icon
      - command line tools for manual un-/mounting
      - LUKS encrypted devices
      - unlocking with keyfiles (requires udisks 2.6.4)
      - loop devices (mounting iso archives)
      - password caching (requires python keyutils 0.3)
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
