{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  pytestCheckHook,
  fhir-core,
  pydantic,
  requests,
  unixtools,
}:

buildPythonPackage rec {
  pname = "fhir-resources";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nazrulworld";
    repo = "fhir.resources";
    tag = version;
    hash = "sha256-KKE08BKf8E95y9Wq+21V64dmFv8oL8PwZYBO5oo0fWk=";
  };

  # pytest-runner was removed from Nixpkgs:
  postPatch = ''
    substituteInPlace setup.py --replace-fail '["pytest-runner"]' '[]'
  '';

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    fhir-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
    requests
    unixtools.ping
  ];

  # test directories have their own conftest.py files,
  # so cannot be tested from root directory as per .travis.yml;
  # also, tests in fhir/resources/*/tests/* try to access internet
  preCheck = ''cd tests'';

  pythonImportsCheck = [ "fhir.resources" ];

  meta = {
    description = "Tools and classes to create and manipulate FHIR Resources";
    homepage = "https://github.com/nazrulworld/fhir.resources";
    changelog = "https://github.com/nazrulworld/fhir.resources/blob/main/HISTORY.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
