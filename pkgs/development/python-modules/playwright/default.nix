{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, greenlet
, websockets
, pyee
, pillow
, pixelmatch
, autobahn
, pyopenssl
, service-identity
, requests
, objgraph
, callPackage
, nodejs
}:

buildPythonPackage rec {
  pname = "playwright";
  version = "1.22.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-python";
    rev = "v${version}";
    sha256 = "sha256-nodm1Wts61vRCqjqNX54tD0cQB7uoxx6Eypz7nBR54E=";
  };

  format = "pyproject";

  playwright-driver = callPackage ./driver.nix { playwrightVersion = version; };

  postPatch = ''
    # works with pyee 9 as well, which is what nixos has packaged
    # disables setuptools-scm, as it fails
    substituteInPlace meta.yaml --replace "- pyee ==8.1.0" ""
    substituteInPlace setup.py \
        --replace '"pyee==8.1.0",' "" \
        --replace '"setuptools-scm==6.3.2",' ""
    # replace functionality that setuptools-scm provides by adding the version to a file
    echo 'version = "${version}"' > playwright/_repo_version.py
  '';

  preBuild = ''
    mkdir -p driver
    cp -r ${playwright-driver}/driver ./
  '';

  preInstall = ''
    # pip names the wheel "dist", but when installing it will
    # expect a properly formatted filename in dist.
    mv dist dist.orig
    mkdir -p dist
    mv dist.orig dist/playwright-${version}-py3-none-any.whl
  '';

  propagatedBuildInputs = [
    playwright-driver
    greenlet
    websockets
    pyee
    pillow
    pixelmatch
    autobahn
    pyopenssl
    service-identity
    requests
    objgraph
  ];

  # skip tests because they require network access
  doCheck = false;

  pythonImportsCheck = [
    "playwright"
  ];

  postInstall = ''
    # use nix's nodejs instead of playwright's nodejs
    substituteInPlace "$out/lib/${python.libPrefix}/site-packages/playwright/driver/playwright.sh" \
      --replace '"$SCRIPT_PATH/node"' '"${nodejs}/bin/node"'
  '';

  meta = with lib; {
    description = "Python version of the Playwright testing and automation library";
    homepage = "https://github.com/microsoft/playwright-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ techknowlogick ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  };
}
