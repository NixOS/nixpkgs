{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core_3,
  platformdirs,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fissix";
  version = "26.10.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amyreese";
    repo = "fissix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q1Du3o6VStqrsQkPKaVgcFhrk7PW4C3ctm6VRccoxzA=";
  };

  build-system = [ flit-core_3 ];

  dependencies = [ platformdirs ];

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
})
