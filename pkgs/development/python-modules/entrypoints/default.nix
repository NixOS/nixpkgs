{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-twbt2qkhihnrzWe1aBjwW7J1ibHKno15e3Sv+tTMrNQ=";
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
