{
  stdenv,
  pkgs,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python3Packages,
  texlive,
  chromium,
  pandoc,
  playwright-driver,
}:

let
  version = "0.2.7";

  pythonDeps = with python3Packages; [
    notebook
    ipykernel
    pytest
    pytest-asyncio
    matplotlib
    pandas
    html2image
    nbconvert
    aiohttp
    requests
    pillow
    packaging
    mistune
    lxml
    beautifulsoup4
    cssutils
    playwright
    chromium
    pandoc
    setuptools-scm
    cssselect
    # selenium
  ];

  testDeps = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  systemDeps = [
    texlive.combined.scheme-small
    playwright-driver.browsers
    chromium
    pandoc
    # pkgs.firefox-unwrapped
    # pkgs.geckodriver
  ];

in
python3Packages.buildPythonPackage rec {
  pname = "dataframe_image";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dexplo";
    repo = "dataframe_image";
    tag = "v${version}";
    hash = "sha256-rX3afHEKGBZHkHPPKZFPiw6lt7lRYkpMhKvZIorXFok=";
  };

  nativeBuildInputs = testDeps ++ systemDeps;
  buildInputs = with python3Packages; [ setuptools ];
  propagatedBuildInputs = pythonDeps ++ systemDeps;
  nativeCheckInputs = testDeps ++ systemDeps ++ (with python3Packages; [ pytestCheckHook ]);

  pythonImportsCheck = [ "dataframe_image" ];
  doCheck = true;

  preCheck = ''
    export HOME=$TMPDIR
    export JUPYTER_PLATFORM_DIRS=1
    export MPLCONFIGDIR=$TMPDIR/matplotlib
    export PLAYWRIGHT_BROWSERS_PATH=${playwright-driver.browsers}
    # export PATH="${pkgs.geckodriver}/bin:$PATH"
  '';

  makeWrapperArgs = [
    "--set PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}"
    # "--prefix PATH : ${pkgs.geckodriver}/bin"
  ];

  pytestFlagsArray = [
    "-k 'not selenium and not test_latex[playwright]'"
    # The selenium tests are failing as firefox drivers cannot be found.
    # test_latex[playwright] is timing out.
    #
    # As dfi.export( ... ,table_conversion="chrome") works with the current
    # build, and therefore selenium seems unnecessary, I'm disabling these
    # tests.
    #
    # More specifically, these are the errors I'm getting:
    #
    # E           selenium.common.exceptions.WebDriverException: Message:
    # Unsupported platform/architecture combination: linux/aarch64
    #
    # E           selenium.common.exceptions.NoSuchDriverException: Message: Unable
    # to obtain driver for firefox; For documentation on this error, please visit:
    # https://www.selenium.dev/documentation/webdriver/troubleshooting/errors/driver_location
    #
    # For the latter, the solution described on the webpage is to add the driver
    # location to the path. As the linked driver is gecko driver, I included this
    # in dependencies and I added geckodriver's binary to PATH in preCheck and
    # makeWrapperArgs. However, this did not resolve the test failures.
    #
    # I've left in selenium/firefox dependencies I used as comments for
    # convenience.

  ];

  meta = {
    description = "Embed pandas DataFrames as images in pdf and markdown files when converting from Jupyter Notebooks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lnajt ];
    homepage = "https://www.dexplo.org/dataframe_image/";
    downloadPage = "https://github.com/dexplo/dataframe_image";
    changelog = "https://github.com/dexplo/dataframe_image/releases/tag/v${version}";
  };
}
