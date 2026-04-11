{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # patches
  replaceVars,
  nodejs,
  playwright-driver,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  gitMinimal,
  writableTmpDirAsHomeHook,

  # dependencies
  greenlet,
  pyee,

  python,
  nixosTests,
}:

let
  driver = playwright-driver;
in
buildPythonPackage (finalAttrs: {
  pname = "playwright";
  # run ./pkgs/development/web/playwright/update.sh to update
  version = "1.58.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gK19pjB8TDy/kK+fb4pjwlGZlUyY26p+CNxunvIMrrY=";
  };

  patches = [
    # This patches two things:
    # - The driver location, which is now a static package in the Nix store.
    # - The setup script, which would try to download the driver package from
    #   a CDN and patch wheels so that they include it. We don't want this
    #   we have our own driver build.
    (replaceVars ./driver-location.patch {
      driver = "${driver}/cli.js";
      nodejs = lib.getExe nodejs;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "auditwheel==6.2.0"' "" \
      --replace-fail "setuptools-scm==8.3.1" "setuptools-scm" \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "wheel==0.45.1" "wheel"

    # setup.py downloads and extracts the driver.
    # This is done manually in postInstall instead.
    rm setup.py
  '';

  build-system = [
    setuptools-scm
    setuptools
  ];

  nativeBuildInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  pythonRelaxDeps = [
    "greenlet"
    "pyee"
  ];
  dependencies = [
    greenlet
    pyee
  ];

  postInstall = ''
    ln -s ${driver} $out/${python.sitePackages}/playwright/driver
  '';

  # Skip tests because they require network access.
  doCheck = false;

  pythonImportsCheck = [ "playwright" ];

  passthru = {
    inherit driver;
    tests = {
      inherit driver;
      browsers = playwright-driver.browsers;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) playwright-python;
    };
    # Package and playwright driver versions are tightly coupled.
    # Use the update script to ensure synchronized updates.
    skipBulkUpdate = true;
  };

  meta = {
    description = "Python version of the Playwright testing and automation library";
    mainProgram = "playwright";
    homepage = "https://github.com/microsoft/playwright-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      techknowlogick
      yrd
      kalekseev
    ];
  };
})
