{ ansicolors
, attrs
, autobahn
, buildPythonPackage
, fetchFromGitHub
, jinja2
, lib
, mock
, packaging
, pexpect
, psutil
, pyserial
, pytestCheckHook
, pytest-dependency
, pytest-mock
, pyudev
, pyusb
, pyyaml
, requests
, setuptools
, setuptools-scm
, wheel
, xmodem
}:

buildPythonPackage rec {
  pname = "labgrid";
  version = "23.0.4";

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-EEPQSIHKAmLPudv7LLm9ol3Kukgz8edYKfDi+wvERpk=";
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

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  nativeCheckInputs = [
    mock
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
