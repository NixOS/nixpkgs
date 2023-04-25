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
  version = "23.0.1";

  src = fetchFromGitHub {
    owner = "labgrid-project";
    repo = "labgrid";
    rev = "v${version}";
    sha256 = "sha256-k/ReNr4GVrR/ghyzyQAo8NB6Eklno1/0fVMTyZk69SI=";
  };
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'ansicolors==1.1.8' 'ansicolors>=1.1.8' \
      --replace '"attrs==21.4.0"' '"attrs>=21.4.0"' \
      --replace '"autobahn==21.3.1"' '"autobahn>=21.3.1"' \
      --replace '"jinja2==3.0.2"' '"jinja2>=3.0.2"' \
      --replace '"packaging==21.0"' '"packaging>=21.0"' \
      --replace '"pexpect==4.8.0"' '"pexpect>=4.8.0"' \
      --replace '"pyserial-labgrid>=3.4.0.1"' '"pyserial>=3.4"' \
      --replace '"pytest==7.2.2",' "" \
      --replace '"pyudev==0.22.0"' '"pyudev>=0.22.0"' \
      --replace '"pyusb==1.2.1"' '"pyusb>=1.2.1"' \
      --replace '"PyYAML==5.4.1"' '"PyYAML>=5.4.1"' \
      --replace '"requests==2.26.0"' '"requests>=2.26.0"' \
      --replace '"xmodem==0.4.6"' '"xmodem>=0.4.6"'
  '';

  nativeBuildInputs = [ setuptools-scm ];

  format = "pyproject";

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
