{
  lib,
  stdenv,
  auditwheel,
  buildPythonPackage,
  git,
  greenlet,
  fetchFromGitHub,
  pyee,
  python,
  pythonOlder,
  setuptools,
  setuptools-scm,
  playwright-driver,
}:

let
  driver = playwright-driver;
in
buildPythonPackage rec {
  pname = "playwright";
  # run ./pkgs/development/python-modules/playwright/update.sh to update
  version = "1.42.0";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GfaZ6wMbJShyTTcV9uulmsL8OI/OA+YDMvS2s3ePnjs=";
  };

  patches = [
    # This patches two things:
    # - The driver location, which is now a static package in the Nix store.
    # - The setup script, which would try to download the driver package from
    #   a CDN and patch wheels so that they include it. We don't want this
    #   we have our own driver build.
    ./driver-location.patch
  ];

  postPatch = ''
    # if setuptools_scm is not listing files via git almost all python files are excluded
    export HOME=$(mktemp -d)
    git init .
    git add -A .
    git config --global user.email "nixpkgs"
    git config --global user.name "nixpkgs"
    git commit -m "workaround setuptools-scm"

    substituteInPlace setup.py \
      --replace "setuptools-scm==8.0.4" "setuptools-scm" \
      --replace-fail "wheel==0.42.0" "wheel"

    substituteInPlace pyproject.toml \
      --replace 'requires = ["setuptools==68.2.2", "setuptools-scm==8.0.4", "wheel==0.42.0", "auditwheel==5.4.0"]' \
                'requires = ["setuptools", "setuptools-scm", "wheel"]'

    # Skip trying to download and extract the driver.
    # This is done manually in postInstall instead.
    substituteInPlace setup.py \
      --replace "self._download_and_extract_local_driver(base_wheel_bundles)" ""

    # Set the correct driver path with the help of a patch in patches
    substituteInPlace playwright/_impl/_driver.py \
      --replace "@driver@" "${driver}/bin/playwright"
  '';

  nativeBuildInputs = [
    git
    setuptools-scm
    setuptools
  ] ++ lib.optionals stdenv.isLinux [ auditwheel ];

  pythonRelaxDeps = [ "pyee" ];

  propagatedBuildInputs = [
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
      driver = playwright-driver;
      browsers = playwright-driver.browsers;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    mainProgram = "playwright";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [
      techknowlogick
      yrd
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
