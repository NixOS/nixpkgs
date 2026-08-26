{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  graphql-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest8_3CheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "apischema";
  version = "0.18.3";
  pyproject = true;

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

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  optional-dependencies = {
    graphql = [ graphql-core ];
  };

  # Hasn't been updated in two years
  doCheck = pythonOlder "3.14";

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
