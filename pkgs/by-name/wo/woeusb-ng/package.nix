{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  p7zip,
  parted,
  grub2,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "woeusb-ng";
  version = "0.2.12-unstable-2026-01-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WoeUSB";
    repo = "WoeUSB-ng";
    # tag = "v${finalAttrs.version}";
    rev = "cc52ffc6aedad12540c2315c9101e4a4b919d4be";
    hash = "sha256-TfrXq8zYtlqcA/jbxQul7HIGdYrn73ljKVY2x4BfS2E=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    wrapGAppsHook3
  ];
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${
        lib.makeBinPath [
          p7zip
          parted
          grub2
        ]
      }"
    )
  '';

  dependencies = [
    python3Packages.termcolor
    python3Packages.wxpython
    python3Packages.six
  ];

  preConfigure = ''
    mkdir -p $out/bin $out/share/applications $out/share/polkit-1/actions
  '';

  # Unable to access the X Display, is $DISPLAY set properly?
  doCheck = false;

  meta = {
    description = "Tool to create a Windows USB stick installer from a real Windows DVD or image";
    homepage = "https://github.com/WoeUSB/WoeUSB-ng";
    mainProgram = "woeusb";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.stunkymonkey ];
    platforms = lib.platforms.linux;
  };
})
