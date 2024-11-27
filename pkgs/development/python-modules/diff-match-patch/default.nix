{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20241021";
  pyproject = true;

  src = fetchPypi {
    pname = "diff_match_patch";
    inherit version;
    hash = "sha256-vq5XqZ+kgIRTKTXuKWi4Zh24YYYuyCxvIfSs3W2DUHM=";
  };

  dependencies = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
