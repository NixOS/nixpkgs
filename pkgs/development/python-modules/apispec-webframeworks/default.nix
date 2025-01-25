{
  lib,
  aiohttp,
  apispec,
  bottle,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  flask,
  mock,
  pytestCheckHook,
  pythonOlder,
  tornado,
}:

buildPythonPackage rec {
  pname = "apispec-webframeworks";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "apispec-webframeworks";
    tag = version;
    hash = "sha256-V4tdqcHfYRh9VoXUTPXM3SIOogJDJB14SLj5dSd7LzU=";
  };

  build-system = [ flit-core ];

  dependencies = [ apispec ] ++ apispec.optional-dependencies.yaml;

  nativeCheckInputs = [
    aiohttp
    bottle
    flask
    mock
    pytestCheckHook
    tornado
  ];

  pythonImportsCheck = [ "apispec_webframeworks" ];

  meta = with lib; {
    description = "Web framework plugins for apispec";
    homepage = "https://github.com/marshmallow-code/apispec-webframeworks";
    changelog = "https://github.com/marshmallow-code/apispec-webframeworks/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
