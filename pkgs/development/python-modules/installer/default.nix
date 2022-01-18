{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, flit-core
, mock
}:

buildPythonPackage rec {
  pname = "installer";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pradyunsg";
    repo = pname;
    rev = version;
    sha256 = "sha256-AxAQgDhRFkb0HB7ttDb+pHuHzwnNDX6UOm9rswzIwmI=";
  };

  nativeBuildInputs = [ flit-core ];

  checkInputs = [
    pytestCheckHook
    mock
  ];

  meta = with lib; {
    homepage = "https://github.com/pradyunsg/installer";
    description = "A low-level library for installing a Python package from a wheel distribution.";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud fridh ];
  };
}
