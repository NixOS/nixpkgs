{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,

  # driver
  jq,

  # nativeBuildInputs
  toml,

  # patches
  replaceVars,
  nodejs,
  playwright-driver,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  greenlet,
  pyee,

  # tests
  versionCheckHook,

  python,
}:

let
  # Patchright is built by patching the playwright-python source with a script from
  # patchright-python, and bundling the patchright-core npm package as the driver.
  # Mirrors upstream's release workflow:
  # https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/blob/main/.github/workflows/patchright_release.yml
  playwrightVersion = "1.64.0";
  driverVersion = "1.64.3";

  # Upstream doesn't tag patchright-python releases anymore
  patcher = fetchFromGitHub {
    owner = "Kaliiiiiiiiii-Vinyzu";
    repo = "patchright-python";
    rev = "8727f3b069a096104824c1ee0a03d61de74735ea";
    hash = "sha256-iInjleWG8XSf9qQwhnYxP5iZBmjpVJWQiDGqBaHNV8U=";
  };

  driver = stdenv.mkDerivation {
    pname = "patchright-core";
    version = driverVersion;
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchzip {
      url = "https://registry.npmjs.org/patchright-core/-/patchright-core-${driverVersion}.tgz";
      hash = "sha256-KF7TDJ4RuX/yfUAvK8ZYf2Wsd8tlq4V1MUquN5Q5wV8=";
    };

    nativeBuildInputs = [ jq ];

    # Same adjustments as playwright-driver, so that the nixpkgs browsers can be used
    postPatch =
      # Nixpkgs packages only the top-level browser revisions
      ''
        jq 'del(.browsers[].revisionOverrides)' browsers.json > browsers.json.tmp
        mv browsers.json.tmp browsers.json
      ''
      # The dlopen library check uses ldconfig which doesn't work under Nix
      + ''
        substituteInPlace lib/coreBundle.js \
          --replace-fail '["libGLESv2.so.2", "libx264.so"]' '[]'
      '';

    installPhase = ''
      runHook preInstall

      cp -r . "$out"

      runHook postInstall
    '';

    meta = {
      description = "Undetected version of the Playwright driver";
      homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright";
      license = lib.licenses.asl20;
      inherit (nodejs.meta) platforms;
    };
  };

in
buildPythonPackage (finalAttrs: {
  pname = "patchright";
  version = "1.64.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    tag = "v${playwrightVersion}";
    hash = "sha256-BVgk+YS0CMVTmK1MQr3iEl+TQrGJXuhlYp4EG6Wd6PU=";
  };

  patches = [
    # Use the driver from the Nix store (applied before the playwright -> patchright renaming)
    (replaceVars ../playwright/driver-location.patch {
      driver = "${driver}/cli.js";
      nodejs = lib.getExe nodejs;
    })
  ];

  postPatch =
    # Unpin build-system requirements (before the patcher rewrites pyproject.toml)
    ''
      grep -q 'requires = \["setuptools==.*", "setuptools-scm==.*", "wheel==.*", "auditwheel==.*"\]' pyproject.toml
      sed -i -e 's/requires = \["setuptools==.*", "setuptools-scm==.*", "wheel==.*", "auditwheel==.*"\]/requires = ["setuptools", "setuptools-scm"]/' pyproject.toml
    ''
    # The patcher expects the playwright-python source in ./playwright-python
    + ''
      mkdir "$NIX_BUILD_TOP/patcher"
      cp ${patcher}/patch_python_package.py ${patcher}/README.md "$NIX_BUILD_TOP/patcher/"
      ln -s "$PWD" "$NIX_BUILD_TOP/patcher/playwright-python"
      pushd "$NIX_BUILD_TOP/patcher"
      playwright_version="v${playwrightVersion}" \
      patchright_version="${finalAttrs.version}" \
      patchright_core_version="${driverVersion}" \
        python patch_python_package.py
      popd
    ''
    # setup.py downloads and extracts the driver, which is linked in postInstall instead
    + ''
      rm setup.py
    '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Required by the patcher script
  nativeBuildInputs = [ toml ];

  pythonRelaxDeps = [
    "greenlet"
    "pyee"
  ];
  dependencies = [
    greenlet
    pyee
  ];

  postInstall = ''
    ln -s ${driver} $out/${python.sitePackages}/patchright/driver
  '';

  pythonImportsCheck = [
    "patchright"
    "patchright.async_api"
    "patchright.sync_api"
  ];

  # Upstream tests require network access and browsers
  nativeCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    inherit driver;
    # patchright-core uses the same browser revisions as the matching playwright-driver
    inherit (playwright-driver) browsers;
    # playwright-python, patchright-core and the patcher versions are coupled
    skipBulkUpdate = true;
  };

  meta = {
    description = "Undetected Python version of the Playwright testing and automation library";
    homepage = "https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python";
    changelog = "https://github.com/microsoft/playwright-python/releases/tag/v${playwrightVersion}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "patchright";
  };
})
