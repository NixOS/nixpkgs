{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphql-core,
  pytest-asyncio,
  pytest8_3CheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apischema";
  version = "0.18.3";
  pyproject = true;

  # Hasn't been updated in two years
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "wyfo";
    repo = "apischema";
    tag = "v${version}";
    hash = "sha256-YFJbNxCwDrJb603Bf8PDrvhVt4T53PNWOYs716c0f1I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.1.0" "setuptools" \
      --replace-fail "wheel~=0.44.0" "wheel"
  '';

  build-system = [ setuptools ];

  optional-dependencies = {
    graphql = [ graphql-core ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest8_3CheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "apischema" ];

  meta = {
    description = "JSON (de)serialization, GraphQL and JSON schema generation using typing";
    homepage = "https://github.com/wyfo/apischema";
    changelog = "https://github.com/wyfo/apischema/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
