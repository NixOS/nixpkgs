{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphql-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apischema";
  version = "0.18.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wyfo";
    repo = "apischema";
    rev = "refs/tags/v${version}";
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
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "apischema" ];

  meta = with lib; {
    description = "JSON (de)serialization, GraphQL and JSON schema generation using typing";
    homepage = "https://github.com/wyfo/apischema";
    changelog = "https://github.com/wyfo/apischema/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
