{ lib
, buildPythonPackage
, cython
, email-validator
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pytest_7
, python-dotenv
, pythonAtLeast
, pythonOlder
, setuptools
, typing-extensions
, libxcrypt
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.10.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    rev = "refs/tags/v${version}";
    hash = "sha256-tcaHSPZggVwyzCgDmwOgcGqUmUrJOmkdSNudJTFQ3bc=";
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
    (pytestCheckHook.override { pytest = pytest_7; })
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    # https://github.com/pydantic/pydantic/issues/4817
    "-W" "ignore::pytest.PytestReturnNotNoneWarning"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # depends on distuils
    "test_cython_function_untouched"
    # AssertionError on exact types and wording
    "test_model_subclassing_abstract_base_classes_without_implementation_raises_exception"
    "test_partial_specification_name"
    "test_secretfield"
  ];

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
