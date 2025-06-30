{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jsonschema,
  pymacaroons,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pypitoken";
  version = "7.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ewjoachim";
    repo = "pypitoken";
    tag = version;
    hash = "sha256-esn7Pbmpo4BAvLefOWMeQNEB0UYwBf9vgcuzmuGwH30=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    pymacaroons
    jsonschema
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pypitoken" ];

  meta = with lib; {
    description = "Library for generating and manipulating PyPI tokens";
    homepage = "https://pypitoken.readthedocs.io/";
    changelog = "https://github.com/ewjoachim/pypitoken/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
