{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "editables";
  version = "0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MJYn2bXErcDmaNjG+nusG6fIxdQVwtJ/YPCB+OgNHeI=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests not included in archive.
  doCheck = false;

  pythonImportsCheck = [ "editables" ];

  meta = {
    description = "Editable installations";
    homepage = "https://github.com/pfmoore/editables";
    changelog = "https://github.com/pfmoore/editables/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
