{ lib
, buildPythonPackage
, git
, greenlet
, fetchFromGitHub
, pyee
, python
, pythonOlder
, setuptools-scm
, playwright-driver
}:

let
  driver = playwright-driver;
in
buildPythonPackage rec {
  pname = "playwright";
  version =  "1.32.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "v${version}";
    hash = "sha256-rguobFaepTOL2duHRdFV5o2JSsBlYiA7rY3/RyHvoMc=";
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
      --replace "greenlet==2.0.1" "greenlet>=2.0.1" \
      --replace "pyee==8.1.0" "pyee>=8.1.0" \
      --replace "setuptools-scm==7.0.5" "setuptools-scm>=7.0.5" \
      --replace "wheel==0.38.1" "wheel>=0.37.1"

    # Skip trying to download and extract the driver.
    # This is done manually in postInstall instead.
    substituteInPlace setup.py \
      --replace "self._download_and_extract_local_driver(base_wheel_bundles)" ""

    # Set the correct driver path with the help of a patch in patches
    substituteInPlace playwright/_impl/_driver.py \
      --replace "@driver@" "${driver}/bin/playwright"
  '';


  nativeBuildInputs = [ git setuptools-scm ];

  propagatedBuildInputs = [
    greenlet
    pyee
  ];

  postInstall = ''
    ln -s ${driver} $out/${python.sitePackages}/playwright/driver
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  # Skip tests because they require network access.
  doCheck = false;

  pythonImportsCheck = [
    "playwright"
  ];

  passthru = {
    inherit driver;
    tests = {
      driver = playwright-driver;
      browsers = playwright-driver.browsers;
    };
  };

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick yrd SuperSandro2000 ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
