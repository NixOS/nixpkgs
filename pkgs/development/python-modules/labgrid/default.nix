{
  ansicolors,
  attrs,
  autobahn,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  lib,
  mock,
  openssh,
  packaging,
  pexpect,
  psutil,
  pyserial,
  pytestCheckHook,
  pytest-dependency,
  pytest-mock,
  pyudev,
  pyusb,
  pyyaml,
  requests,
  setuptools,
  setuptools-scm,
  wheel,
  xmodem,
}:

buildPythonPackage rec {
  pname = "labgrid";
  version = "24.0";

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "refs/tags/v${version}";
    hash = "sha256-XlndAmLkDjb4S2BD85noTMJCeqa5srZocjgg1x6Ry/g=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  pyproject = true;

  propagatedBuildInputs = [
    ansicolors
    attrs
    autobahn
    jinja2
    packaging
    pexpect
    pyserial
    pyudev
    pyusb
    pyyaml
    requests
    xmodem
  ];

  pythonRelaxDeps = [
    "attrs"
    "autobahn"
    "jinja2"
    "packaging"
    "pexpect"
    "pytest"
    "pyudev"
    "requests"
    "xmodem"
  ];

  pythonRemoveDeps = [ "pyserial-labgrid" ];

  nativeCheckInputs = [
    mock
    openssh
    psutil
    pytestCheckHook
    pytest-mock
    pytest-dependency
  ];

  disabledtests = [
    # flaky, timing sensitive
    "test_timing"
  ];

  meta = with lib; {
    description = "Embedded control & testing library";
    homepage = "https://github.com/labgrid-project/labgrid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
