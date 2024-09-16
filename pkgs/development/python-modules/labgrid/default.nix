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
  xmodem,
}:

buildPythonPackage rec {
  pname = "labgrid";
  version = "24.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "refs/tags/v${version}";
    hash = "sha256-KZO6HeB1Kkc3r6OI0ZXIL1WvGLYL5SLxaOn+EX5akOE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    ansicolors
    attrs
    autobahn
    jinja2
    pexpect
    pyserial
    pyudev
    pyusb
    pyyaml
    requests
    xmodem
  ];

  pythonRemoveDeps = [ "pyserial-labgrid" ];

  pythonImportsCheck = [ "labgrid" ];

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
