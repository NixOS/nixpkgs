{ lib, stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, requests
, setuptools, pytestCheckHook, cryptography, typing-extensions }:

buildPythonPackage rec {
  pname = "ccxt";
  version = "4.1.80";
  pyproject = true;

  disabled = pythonOlder "3.10";

  # fetch from Github instead of PyPi because the PyPi package is broken
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-HrWx/swtRpn2vdcnNfCmnFqAmXAPcKV1cTmLvbSR9JY=";
  };

  sourceRoot = "source/python";

  nativeBuildInputs = [ setuptools cryptography ];

  propagatedBuildInputs = [ requests typing-extensions ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ccxt" ];

  meta = with lib; {
    changelog = "https://github.com/ccxt/ccxt/releases/tag/${version}";
    description =
      "A cryptocurrency trading API with support for more than 100 bitcoin/altcoin exchanges";
    homepage = "https://github.com/ccxt/ccxt";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
