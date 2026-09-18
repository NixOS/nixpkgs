{
  lib,
  python3Packages,
  fetchPypi,
  pkg-config,
  librsvg,
  gobject-introspection,
  atk,
  gtk3,
  gtkspell3,
  adwaita-icon-theme,
  glib,
  goocanvas_2,
  gdk-pixbuf,
  pango,
  fontconfig,
  freetype,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tryton";
  version = "7.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-X8jJ/NXbvoKJdKep78inefILaFLjJyAmRMVfdOEb0tk=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook3
  ];

  dependencies = with python3Packages; [
    python-dateutil
    pygobject3
    goocalendar
    pycairo
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    glib
    adwaita-icon-theme
    goocanvas_2
    fontconfig
    freetype
    gtk3
    gtkspell3
    librsvg
    pango
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  strictDeps = false;

  pythonImportsCheck = [ "tryton" ];

  doCheck = false;

  meta = {
    description = "Client of the Tryton application platform";
    mainProgram = "tryton";
    longDescription = ''
      The client for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = "http://www.tryton.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      johbo
      udono
    ];
  };
})
