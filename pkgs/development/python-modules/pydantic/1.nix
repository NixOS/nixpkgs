{ lib
, buildPythonPackage
, cython
, email-validator
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, python-dotenv
, pythonOlder
, setuptools
, typing-extensions
, libxcrypt
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.10.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-ruDVcCLPVuwIkHOjYVuKOoP3hHHr7ItIY55Y6hUgR74=";
  };

  nativeBuildInputs = [
    setuptools
    cython
  ];

  buildInputs = lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  passthru.optional-dependencies = {
    dotenv = [
      python-dotenv
    ];
    email = [
      email-validator
    ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    # https://github.com/pydantic/pydantic/issues/4817
    "-W" "ignore::pytest.PytestReturnNotNoneWarning"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    description = "Data validation and settings management using Python type hinting";
    homepage = "https://github.com/pydantic/pydantic";
    changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
