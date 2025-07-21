{
  lib,
  fetchurl,
  python3Packages,
  mercurial,
  qt5,
}:

python3Packages.buildPythonApplication rec {
  pname = "tortoisehg";
  version = "6.9";
  format = "setuptools";

  src = fetchurl {
    url = "https://www.mercurial-scm.org/release/tortoisehg/targz/tortoisehg-${version}.tar.gz";
    hash = "sha256-j+HuAq/elnXIOoX4eoqMeOyGq3qjbdoJw6pcZsSa+AI=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  dependencies = with python3Packages; [
    mercurial
    # The one from python3Packages
    qscintilla-qt5
    iniparse
  ];

  buildInputs = [
    # Makes wrapQtAppsHook add these qt libraries to the wrapper search paths
    qt5.qtwayland
  ];

  # In order to spare double wrapping, we use:
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';
  # Convenient alias
  postInstall = ''
    ln -s $out/bin/thg $out/bin/tortoisehg
  '';

  # In python3Packages.buildPythonApplication doCheck is always true, and we
  # override it to not run the default unittests
  checkPhase = ''
    runHook preCheck

    $out/bin/thg version | grep -q "${version}"
    # Detect breakage of thg in case of out-of-sync mercurial update. In that
    # case any thg subcommand just opens up an gui dialog with a description of
    # version mismatch.
    echo "thg smoke test"
    $out/bin/thg -h > help.txt &
    sleep 1s
    grep -q "list of commands" help.txt

    runHook postCheck
  '';

  passthru = {
    # If at some point we'll override this argument, it might be useful to have
    # access to it here.
    inherit mercurial;
  };

  meta = {
    description = "Qt based graphical tool for working with Mercurial";
    homepage = "https://tortoisehg.bitbucket.io/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      danbst
      gbtb
    ];
  };
}
