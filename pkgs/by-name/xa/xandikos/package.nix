{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.12";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    tag = "v${version}";
    hash = "sha256-wdEwIVN9dkLVj8oe+2eh5n258pZRfKgLgzVCmwafCis=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    pytz
    vobject
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with lib.maintainers; [ _0x4A6F ];
    mainProgram = "xandikos";
  };
}
