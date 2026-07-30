{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "overrides";
  version = "7.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkorpela";
    repo = "overrides";
    tag = version;
    hash = "sha256-gQDw5/RpAFNYWFOuxIAArPkCOoBYWUnsDtv1FEFteHo=";
  };

  # https://github.com/mkorpela/overrides/pull/136
  patches = [ ./pytest9-compat.patch ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "overrides" ];

  meta = {
    description = "Decorator to automatically detect mismatch when overriding a method";
    homepage = "https://github.com/mkorpela/overrides";
    changelog = "https://github.com/mkorpela/overrides/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
