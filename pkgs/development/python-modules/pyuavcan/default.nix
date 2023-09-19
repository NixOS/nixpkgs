{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, numpy, nunavut
, pyserial , pytest, ruamel-yaml}:

# This has been renamed pycyphal, without any API changes; though this package is
# quite outdated so transition might not be as seemless as it could be
# See https://uavcan.org/ (which will redirect to https://opencyphal.org/)
lib.warn "pyuavcan is deprecated and will be removed in 24.05; use pycyphal instead"
 buildPythonPackage rec {
  pname = "pyuavcan";
  version = "1.1.0.dev1";
  disabled = pythonOlder "3.7"; # only python>=3.7 is supported

  src = fetchFromGitHub {
    owner = "UAVCAN";
    repo = pname;
    rev = version;
    hash = "sha256-ChNoYHuZulPLrxYvxeVO9Tyt8rymlk3p/OkYaG2rqzo=";
  };

  propagatedBuildInputs = [
    numpy
    nunavut
    pyserial
    pytest
    ruamel-yaml
  ];

  # allow for writable directory for darwin
  preBuild = ''
    export HOME=$TMPDIR
    export PYTHONASYNCIODEBUG=1
  '';

  # tests fail ATM.
  doCheck = false;

  # check at least that import works, as tests fail
  pythonImportsCheck = [
    "pyuavcan"
  ];

  meta = with lib; {
    description = "A full-featured implementation of the UAVCAN protocol stack";
    longDescription = ''
      It is intended for non-embedded, user-facing applications such as GUI
      software, diagnostic tools, automation scripts, prototypes, and various
      R&D cases.  PyUAVCAN consists of a Python library (package) and a simple
      CLI tool for basic diagnostics and shell script automation.
    '';
    homepage = "https://pyuavcan.readthedocs.io";
    maintainers = with maintainers; [ wucke13 ];
    license = licenses.mit;
  };
}
