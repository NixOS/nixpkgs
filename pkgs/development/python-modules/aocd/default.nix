{
  lib,
  aocd-example-parser,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pebble,
  pook,
  pytest-freezegun,
  pytest-mock,
  pytest-cov-stub,
  pytest-raisin,
  pytest-socket,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  requests-mock,
  rich,
  setuptools,
  termcolor,
  tzlocal,
}:

buildPythonPackage rec {
  pname = "aocd";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "wimglenn";
    repo = "advent-of-code-data";
    tag = "v${version}";
    hash = "sha256-xR9CfyOUsKSSA/1zYi6kCK3oAaX6Kd625mKMWI+ZFMA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aocd-example-parser
    beautifulsoup4
    pebble
    python-dateutil
    requests
    rich # for example parser aoce. must either be here or checkInputs
    termcolor
    tzlocal
  ];

  nativeCheckInputs = [
    numpy
    pook
    pytest-freezegun
    pytest-mock
    pytest-raisin
    pytest-socket
    pytestCheckHook
    pytest-cov-stub
    requests-mock
  ];

  enabledTestPaths = [
    "tests/"
  ];

  pythonImportsCheck = [ "aocd" ];

  meta = {
    description = "Get your Advent of Code data with a single import statement";
    homepage = "https://github.com/wimglenn/advent-of-code-data";
    changelog = "https://github.com/wimglenn/advent-of-code-data/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aadibajpai ];
    platforms = lib.platforms.unix;
  };
}
