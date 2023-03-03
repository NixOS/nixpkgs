{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, python
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "funcparserlib";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vlasovskikh";
    repo = pname;
    rev = version;
    sha256 = "sha256-moWaOzyF/yhDQCLEp7bc0j8wNv7FM7cvvpCwon3j+gI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [
    "funcparserlib"
  ];

  meta = with lib; {
    description = "Recursive descent parsing library based on functional combinators";
    homepage = "https://github.com/vlasovskikh/funcparserlib";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
