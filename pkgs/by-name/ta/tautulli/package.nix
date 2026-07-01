{
  lib,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "tautulli";
  version = "2.17.2";
  pyproject = false;

  pythonPath = [ python3Packages.setuptools ];
  nativeBuildInputs = [
    python3Packages.wrapPython
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "Tautulli";
    repo = "Tautulli";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-BtKVGXJijxGK3CH0J49WKxBFG0pAp+zAw7YIJ4w5PCk=";
  };

  postPatch = ''
    substituteInPlace plexpy/config.py \
      --replace-fail "'CHECK_GITHUB': (int, 'General', 1)" "'CHECK_GITHUB': (int, 'General', 0)"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/tautulli
    cp -R contrib data lib plexpy Tautulli.py CHANGELOG.md $out/libexec/tautulli

    echo "master" > $out/libexec/tautulli/branch.txt
    echo "v${finalAttrs.version}" > $out/libexec/tautulli/version.txt

    # Can't just symlink to the main script, since it uses __file__ to
    # import bundled packages and manage the service
    makeWrapper $out/libexec/tautulli/Tautulli.py $out/bin/tautulli
    wrapPythonProgramsIn "$out/libexec/tautulli" "''${pythonPath[*]}"

    # Creat backwards compatibility symlink to bin/plexpy
    ln -s $out/bin/tautulli $out/bin/plexpy

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/tautulli --help

    runHook postCheck
  '';

  meta = {
    description = "Python based monitoring and tracking tool for Plex Media Server";
    homepage = "https://tautulli.com/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rhoriguchi ];
  };
})
