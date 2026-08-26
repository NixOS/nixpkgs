{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  uv-build,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "datamodeldict";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "DataModelDict";
    tag = "v${version}";
    hash = "sha256-4tyf3zlzxbtHkvADP+Kmw3/XMugAGi4FNO0qM16m8DU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.26,<0.12" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ xmltodict ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "DataModelDict" ];

  meta = {
    description = "Class allowing for data models equivalently represented as Python dictionaries, JSON, and XML";
    homepage = "https://github.com/usnistgov/DataModelDict/";
    changelog = "https://github.com/usnistgov/DataModelDict/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
