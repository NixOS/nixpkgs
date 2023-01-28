{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "4.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "bitstring-${version}";
    hash = "sha256-eHP20F9PRe9ZNXjcDcsI3iFVswA6KtRWhBMAT7dkCv0=";
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
