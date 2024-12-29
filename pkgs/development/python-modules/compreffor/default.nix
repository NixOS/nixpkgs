{
  lib,
  buildPythonPackage,
  cython,
  fetchpatch,
  fetchPypi,
  setuptools-scm,
  fonttools,
  pytestCheckHook,
  wheel,
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.5.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9NMmIJC8Q4hRC/H2S7OrgoWSQ9SRIPHxHvZpPrPCvHo=";
  };

  patches = [
    # https://github.com/googlefonts/compreffor/pull/153
    (fetchpatch {
      name = "remove-setuptools-git-ls-files.patch";
      url = "https://github.com/googlefonts/compreffor/commit/10f563564390568febb3ed1d0f293371cbd86953.patch";
      hash = "sha256-wNQMJFJXTFILGzAgzUXzz/rnK67/RU+exYP6MhEQAkA=";
    })
  ];

  nativeBuildInputs = [
    cython
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests cannot seem to open the cpython module.
  doCheck = false;

  pythonImportsCheck = [ "compreffor" ];

  meta = with lib; {
    description = "CFF table subroutinizer for FontTools";
    mainProgram = "compreffor";
    homepage = "https://github.com/googlefonts/compreffor";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
