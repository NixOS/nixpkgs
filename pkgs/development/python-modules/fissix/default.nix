{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  appdirs,
  pytestCheckHook,
}:

let
  version = "24.4.24";
in

buildPythonPackage {
  pname = "fissix";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "fissix";
    rev = "v${version}";
    hash = "sha256-geGctke+1PWFqJyiH1pQ0zWj9wVIjV/SQ5njOOk9gOw=";
  };

  build-system = [ flit-core ];

  dependencies = [ appdirs ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "fissix" ];

  meta = {
    description = "Backport of latest lib2to3, with enhancements";
    homepage = "https://github.com/amyreese/fissix";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.emily ];
  };
}
