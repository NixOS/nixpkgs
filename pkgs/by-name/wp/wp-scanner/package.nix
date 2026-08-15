{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wp-scanner";
  version = "3.0.0";
  pyproject = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Triotion";
    repo = "WP-Scanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XTUWL1M2JLqswZsrsew7GlzaZttA39oyHK2zFvPHMfE=";
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
    changelog = "https://github.com/Triotion/WP-Scanner/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wp-scanner";
  };
})
