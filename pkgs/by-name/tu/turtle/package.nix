{ lib
, fetchFromGitLab
, cacert
, gobject-introspection
, gtk4
, glib
, libadwaita
, meld
, python3
, wrapGAppsHook4
}:

python3.pkgs.buildPythonApplication rec {
  pname = "turtle";
  version = "0.6";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "philippun1";
    repo = pname;
    rev = version;
    hash = "sha256-ShZlGZeIjsMOLrdPsl6WphGZcWPrhTQHv2b7HFVm4do=";
  };
  format = "setuptools";
  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];
  buildInputs = [
    libadwaita
    gtk4
    glib
  ];
  nativeCheckInputs = [
    cacert
  ];

  postInstall = ''
    install -Dm644 -t $out/share/nautilus-python/extensions $src/plugins/turtle_nautilus.py
  '';

  # this runs after the wrapPythonScipts function, hence $program_PYTHONPATH is already populated.
  # the turtle_nautilus.py plugin imports turtlevcs, hence we have to patch it
  postFixup = ''
    patchPythonScript "$out/share/nautilus-python/extensions/turtle_nautilus.py"
  '';

  propagatedBuildInputs =
    (with python3.pkgs; [
      pygit2
      pygobject3
    ])
    ++ [
      meld
    ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    # It can't find pygit2 without also adding $PYTHONPATH to the wrapper
    makeWrapperArgs+=( --prefix PYTHONPATH : $out/${python3.sitePackages}:$PYTHONPATH )
  '';

  # breaks gobject-introspection
  strictDeps = false;

  meta = with lib; {
    description = "A graphical interface for version control intended to run on gnome and nautilus";
    homepage = "https://gitlab.gnome.org/philippun1/turtle";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ burniintree ];
    platforms = platforms.linux;
  };
}
