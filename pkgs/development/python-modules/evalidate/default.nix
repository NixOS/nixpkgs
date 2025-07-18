{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  conda,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "evalidate";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yaroslaff";
    repo = "evalidate";
    tag = "v${version}";
    hash = "sha256-2WsvLHbzwHBRyrGCU6eGPl4psAlu8Ko4hRSFr5C+upw=";
  };

  build-system = [ hatchling ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "evalidate" ];

  meta = {
    description = "Safe and fast evaluation of untrusted user-supplied python expressions";
    homepage = "https://github.com/yaroslaff/evalidate";
    changelog = "https://github.com/yaroslaff/evalidate/releases";
    maintainers = with lib.maintainers; [ pandapip1 ];
    license = lib.licenses.mit;
  };
}
