{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O+vZos0F4IsSO+dMJ3s23ko46JnbpqhKyZYuvgwi7OY=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = "https://github.com/takluyver/entrypoints";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
