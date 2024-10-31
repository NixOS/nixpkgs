{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "diff-match-patch";
  version = "20230430";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lTAZzbnJ0snke1sSvP889HRvxFmOtAYHb6H8J+ah8Vw=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/diff-match-patch-python/diff-match-patch";
    description = "Diff, Match and Patch libraries for Plain Text";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
