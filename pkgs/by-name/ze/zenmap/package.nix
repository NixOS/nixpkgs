{
  gobject-introspection,
  gtk3,
  lib,
  nmap,
  python3Packages,
  wrapGAppsHook3,
  xterm,
}:

python3Packages.buildPythonApplication rec {
  pname = "zenmap";
  version = nmap.version;
  pyproject = true;

  src = nmap.src;

  prePatch = ''
    cd zenmap
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-gettext
  ];

  buildInputs = [
    nmap
    gtk3
    xterm
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  nativeCheckInputs = [
    nmap
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ nmap ]})
  '';
  postInstall = ''
    # Icons
    install -Dm 644 "zenmapCore/data/pixmaps/zenmap.png" -t "$out/share/pixmaps/"
    # Desktop-files for application
    install -Dm 644 "install_scripts/unix/zenmap.desktop" -t "$out/share/applications/"
    install -Dm 644 "install_scripts/unix/zenmap-root.desktop" -t "$out/share/applications/"
    install -Dm 755 "install_scripts/unix/su-to-zenmap.sh" -t "$out/bin/"
    substituteInPlace "$out/bin/su-to-zenmap.sh" \
        --replace-fail 'COMMAND="zenmap"' \
                      'COMMAND="'"$out/bin/zenmap"'"' \
        --replace-fail 'xterm' \
                      '"${xterm}/bin/xterm"'
  '';

  checkPhase = ''
    runHook preCheck

    cd test
    ${python3Packages.python.interpreter} run_tests.py 2>&1 | tee /dev/stderr | tail -n1 | grep '^OK$'

    runHook postCheck
  '';

  meta = nmap.meta // {
    description = "Offical nmap Security Scanner GUI";
    homepage = "https://nmap.org/zenmap/";
    maintainers = with lib.maintainers; [
      dvaerum
      mymindstorm
    ];
  };
}
