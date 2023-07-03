{
  buildPythonPackage,
  lib,
  fetchFromGitHub,

  pytestCheckHook,
  pytest-subprocess,
  xonsh,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "xontrib-vox";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "xonsh";
    repo = "xontrib-vox";
    rev = version;
    hash = "sha256-OB1O5GZYkg7Ucaqak3MncnQWXhMD4BM4wXsYCDD0mhk=";
  };

  prePatch = ''
    substituteInPlace pyproject.toml \
      --replace '"xonsh>=0.12.5"' ""
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    "test_interpreter"
  ];

  propagatedInputs = [
    virtualenv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subprocess
    xonsh
  ];

  meta = with lib; {
    description = "Python virtual environment manager for the xonsh shell";
    homepage = "https://github.com/xonsh/xontrib-vox";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };
}
