{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  gtk3,
  gobject-introspection,
  wrapGAppsHook3,
  adwaita-icon-theme,
  writableTmpDirAsHomeHook,
  xvfb-run,
}:

# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins dependencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).

python3Packages.buildPythonApplication rec {
  pname = "zim";
  version = "0.76.3";
  format = "setuptools";

  src = fetchurl {
    url = "https://zim-wiki.org/downloads/zim-${version}.tar.gz";
    hash = "sha256-St8J6z8HcTj+Vb8m8T5sTZk2Fv5CSnmdG6a+CYzk6wU=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
  ];

  dependencies = with python3Packages; [
    pyxdg
    pygobject3
  ];

  # (test.py:800): GLib-GIO-ERROR **: 20:59:45.754:
  # No GSettings schemas are installed on the system
  doCheck = false;

  nativeCheckInputs = [
    xvfb-run
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    xvfb-run ${python3Packages.python.interpreter} test.py

    runHook postCheck
  '';

  postInstall = ''
    (
      cd icons
      for img in *.{png,svg}; do
        size=''${img#zim}
        size=''${size%.png}
        size=''${size%.svg}
        dimensions="''${size}x''${size}"
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp $img $out/share/icons/hicolor/$dimensions/apps/zim.png
      done
    )
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : $out/share)
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : ${adwaita-icon-theme}/share)
    makeWrapperArgs+=(--argv0 $out/bin/.zim-wrapped)
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Desktop wiki";
    homepage = "https://zim-wiki.org/";
    changelog = "https://github.com/zim-desktop-wiki/zim-desktop-wiki/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "zim";
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}
