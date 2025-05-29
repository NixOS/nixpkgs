{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "json-api-doc";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "julien-duponchelle";
    repo = "json-api-doc";
    tag = "v${version}";
    hash = "sha256-r6XduJ2GIr2hGen6hoNIdE3yqPzHJ9xAFOSbMgErsNA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_api_doc" ];

  meta = {
    description = "JSON API parser returning a simple Python dictionary";
    homepage = "https://github.com/julien-duponchelle/json-api-doc";
    changelog = "https://github.com/julien-duponchelle/json-api-doc/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
