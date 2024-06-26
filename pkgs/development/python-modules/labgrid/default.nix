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
  pythonRelaxDepsHook,
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
  version = "23.0.5";

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "refs/tags/v${version}";
    hash = "sha256-jrapbSrybuLT3V11rvV342tOr7/sRwBMgAdNWDG5obA=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
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

  meta = with lib; {
    description = "Embedded control & testing library";
    homepage = "https://labgrid.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
