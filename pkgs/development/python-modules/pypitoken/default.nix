{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonschema,
  poetry-core,
  pymacaroons,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pypitoken";
  version = "7.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ewjoachim";
    repo = "pypitoken";
    rev = "refs/tags/${version}";
    hash = "sha256-1SUR6reZywgFpSdD49E5PjEDNrlvsHH4TK6SkXStUws=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ poetry-core ];

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
