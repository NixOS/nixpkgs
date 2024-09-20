{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ao/zqt8GCcH9J42OowiSmUEqeoub0AXdCLn4KFvLXPw=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    changelog = "https://github.com/kjd/idna/releases/tag/v${version}";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
