{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build
  cython,
  setuptools-scm,
  setuptools,

  # propagates
  defcon,
  fonttools,

  # tests
  pytestCheckHook,
}:

let
  pname = "cu2qu";
  version = "1.6.7.post2";
in
buildPythonPackage rec {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HfVi2ZvWBZImCI9ENwK/Uc/djMY2I/IxN0WaeNe/WAg=";
    extension = "zip";
  };

  nativeBuildInputs = [
    cython
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    defcon
    fonttools
  ] ++ fonttools.optional-dependencies.ufo;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/googlefonts/cu2qu/releases/tag/v${version}";
    description = "Cubic-to-quadratic bezier curve conversion";
    mainProgram = "cu2qu";
    homepage = "https://github.com/googlefonts/cu2qu";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
