{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  wrapt,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pytest-insta";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vberlier";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-kXsKM84yXdGE89KxUtxT2mINmS2lXkuEqB6a9oXZqGo=";
  };

  build-system = [ poetry-core ];

  buildInputs = [ pytest ];

  dependencies = [ wrapt ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_insta" ];

  meta = {
    description = "Pytest plugin for snapshot testing";
    homepage = "https://github.com/vberlier/pytest-insta";
    changelog = "https://github.com/vberlier/pytest-insta/blob/v${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
