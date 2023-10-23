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
, setuptools-scm
, xmodem
}:

buildPythonPackage rec {
  pname = "labgrid";
  version = "23.0.3";

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-yhlBqqCLOt6liw4iv8itG6E4QfIa7cW76QJqefUM5dw=";
  };

  patches = [
    # Pyserial within Nixpkgs already includes the necessary fix, remove the
    # pyserial version check from labgrid.
    ./0001-serialdriver-remove-pyserial-version-check.patch
  ];

  nativeBuildInputs = [ setuptools-scm ];

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
