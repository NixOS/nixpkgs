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
  goocanvas2,
  gdk-pixbuf,
  pango,
  fontconfig,
  freetype,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "tryton";
  version = "7.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yZHHtTVVjiGUT0PA8q5MBBvh04JqMlWOscnA09QD0Yk=";
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
    goocanvas2
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

  meta = with lib; {
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      johbo
      udono
    ];
  };
}
