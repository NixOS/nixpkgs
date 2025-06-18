{
  lib,
  stdenv,

  chromedriver,
  python3,

  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "undetected-chromedriver";
  inherit (chromedriver) version;

  nativeBuildInputs = [ (python3.withPackages (ps: [ ps.undetected-chromedriver ])) ];

  buildCommand = ''
    export HOME=$(mktemp -d)

    cp ${chromedriver}/bin/chromedriver .
    chmod +w chromedriver

    python <<EOF
    import logging
    from undetected_chromedriver.patcher import Patcher

    logging.basicConfig(level=logging.DEBUG)

    success = Patcher(executable_path="chromedriver").patch()
    assert success, "Failed to patch ChromeDriver"
    EOF

    install -D -m 0555 chromedriver $out/bin/undetected-chromedriver
  '';

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = chromedriver.meta // {
    description = "Custom Selenium ChromeDriver that passes all bot mitigation systems";
    mainProgram = "undetected-chromedriver";
    maintainers = with lib.maintainers; [ paveloom ];
  };
})
