{
  lib,
  buildPythonPackage,
  python,
  cffi,
  clingo,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  inherit (clingo) pname version src;

  postPatch = ''
    cd libpyclingo
    python compile.py h
  '';

  pyproject = true;
  build-system = [ setuptools ];

  dependencies = [ cffi ];
  nativeBuildInputs = [ python ];
  nativeCheckInputs = [ pytestCheckHook ];
  buildInputs = [ clingo ];

  pythonImportsCheck = [ "clingo" ];

  meta = {
    inherit (clingo.meta)
      description
      license
      platforms
      homepage
      ;
    maintainers = with lib.maintainers; [ pandapip1 ];
    downloadPage = "https://pypi.org/project/clingo/";
  };
}
