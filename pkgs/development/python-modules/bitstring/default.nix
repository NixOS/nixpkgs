{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  bitarray,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "bitstring";
  version = "4.1.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "scott-griffiths";
    repo = pname;
    rev = "refs/tags/bitstring-${version}";
    hash = "sha256-CO7R2SCb232OW1DCLo45UIarFG5FhR4WkwuQieXha0Y=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ bitarray ];

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
