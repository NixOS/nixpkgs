{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3Packages,
  installShellFiles,
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    tag = "v${version}";
    hash = "sha256-f5x3MH8hH9lSxyh2lrLN4BCOKNDj/bT8yLRPiHaSawI=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    aiosmtpd
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    vobject
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/xandikos{,-milter}.8
  '';

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
