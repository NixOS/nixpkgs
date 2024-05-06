{
  lib,
  fetchFromGitLab,
  glib,
  python3Packages,
  gobject-introspection,
  gsettings-desktop-schemas,
  tor,
  wrapGAppsHook4,
}:

let
  # This package should be updated together with pkgs/by-name/ca/carburetor/package.nix
  version = "5.0.0";
in
python3Packages.buildPythonApplication {
  pname = "tractor";
  inherit version;

  pyproject = true;

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "tractor";
    repo = "tractor";
    rev = version;
    hash = "sha256-KyVL3dFofoi2TRtZo557X9P/RD16v94VuWdtdAskZk4=";
  };

  patches = [ ./fix-gsettings-schema.patch ];

  nativeBuildInputs = [
    glib
    gobject-introspection
    gsettings-desktop-schemas
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    tor
  ];

  dependencies = [
    python3Packages.setuptools
    python3Packages.fire
    python3Packages.pygobject3
    python3Packages.pysocks
    python3Packages.stem
  ];

  postInstall = ''
    mkdir -p "$out/share/glib-2.0/schemas"
    cp "$src/src/tractor/tractor.gschema.xml" "$out/share/glib-2.0/schemas"
    glib-compile-schemas "$out/share/glib-2.0/schemas"
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://framagit.org/tractor/tractor";
    description = "setup a proxy with Onion Routing via TOR and optionally obfs4proxy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "tractor";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
