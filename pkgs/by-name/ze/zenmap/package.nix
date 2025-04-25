{
  lib,
  python3Packages,
  nmap,
  xterm,
  gtk3,
  wrapGAppsHook3,
  gobject-introspection,
}:

python3Packages.buildPythonPackage rec {
  pname = "zenmap";
  version = nmap.version;
  src = nmap.src;
  sourceRoot = "${nmap.name}/zenmap";

  format = "pyproject";

  buildInputs = [
    nmap
    xterm
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    setuptools
    pygobject3
  ];

  postInstall = ''
    wrapProgram "$out/bin/zenmap" \
      --prefix PATH : ${lib.makeBinPath [ nmap ]}

    # Icons
    install -Dm 644 "zenmapCore/data/pixmaps/zenmap.png" -t "$out/share/pixmaps/"

    # Desktop-files for application
    install -Dm 644 "install_scripts/unix/zenmap.desktop" -t "$out/share/applications/"
    substituteInPlace "$out/share/applications/zenmap.desktop" \
        --replace-fail "Exec=zenmap %F" \
                      "Exec=$out/bin/zenmap %F"

    install -Dm 644 "install_scripts/unix/zenmap-root.desktop" -t "$out/share/applications/"
    substituteInPlace "$out/share/applications/zenmap-root.desktop" \
        --replace-fail "TryExec=su-to-zenmap.sh" \
                      "TryExec=$out/bin/su-to-zenmap.sh" \
        --replace-fail "Exec=su-to-zenmap.sh %F" \
                      "Exec=$out/bin/su-to-zenmap.sh %F"

    install -Dm 755 "install_scripts/unix/su-to-zenmap.sh" -t "$out/bin/"
    substituteInPlace "$out/bin/su-to-zenmap.sh" \
        --replace-fail 'COMMAND="zenmap"' \
                      'COMMAND="'"$out/bin/zenmap"'"' \
        --replace-fail 'xterm' \
                      '"${xterm}/bin/xterm"'
  '';

  checkPhase = ''
    cd test
    ${python3Packages.python.interpreter} run_tests.py
  '';

  meta = nmap.meta // {
    description = "GUI for nmap, a free and open source utility for network discovery and security auditing";

    homepage = "https://nmap.org/zenmap/";

    # I believe that will work on all platforms,
    # but I have only able to tested it on Linux (x86_64 & aarch64)
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      dvaerum
    ];
  };
}
