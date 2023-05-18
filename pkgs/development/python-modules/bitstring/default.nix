{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "4.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "bitstring-${version}";
    hash = "sha256-LghfDjf/Z1dEU0gjH1cqMb04ChnW+aGDjmN+RAhMWW8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "bitstring" ];

  meta = with lib; {
    description = "Module for binary data manipulation";
    homepage = "https://github.com/scott-griffiths/bitstring";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
