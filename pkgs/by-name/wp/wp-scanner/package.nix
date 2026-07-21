{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wp-scanner";
  version = "2.0.1-unstable-2026-03-17";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Triotion";
    repo = "WP-Scanner";
    rev = "1f75728384ca5422f69cf5f1d0a284c36b0ed45a";
    hash = "sha256-gIfOxoiVdRKa2GGDy9GMi7+6u2Lh/yVdin/hY9lh4bs=";
  };

  dependencies = with python3.pkgs; [
    beautifulsoup4
    colorama
    lxml
    packaging
    python-dateutil
    requests
    tqdm
    urllib3
  ];

  installPhase = ''
    runHook preInstall

    install -vD wp_scanner.py $out/bin/wp-scanner
    install -vd $out/${python3.sitePackages}/
    cp -R data modules $out/${python3.sitePackages}

    runHook postInstall
  '';

  # Project has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wordpress Security Scanner and Auto Exploiter";
    homepage = "https://github.com/Triotion/WP-Scanner";
    # https://github.com/Triotion/WP-Scanner/issues/2
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wp-scanner";
  };
})
