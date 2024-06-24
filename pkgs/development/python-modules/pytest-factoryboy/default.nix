{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # unpropagated
  pytest,

  # propagated
  inflection,
  factory-boy,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-factoryboy";
  version = "2.6.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-factoryboy";
    rev = version;
    sha256 = "sha256-GYqYwtbmMWVqImVPPBbZNRJJGcbksUPsIbi6QuPRMco=";
  };

  nativeBuildInputs = [ poetry-core ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    factory-boy
    inflection
    typing-extensions
  ];

  pythonImportsCheck = [ "pytest_factoryboy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "--ignore=docs" ];

  meta = with lib; {
    description = "Integration of factory_boy into the pytest runner";
    homepage = "https://pytest-factoryboy.readthedocs.io/en/latest/";
    maintainers = with maintainers; [ winpat ];
    license = licenses.mit;
  };
}
