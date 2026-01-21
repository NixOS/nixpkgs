{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools-scm,
  fonttools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "compreffor";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fqA0pQxZzHhzLxSABA6sK7Nvgmzi62B8MCm104qxG6g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_git_ls_files",' ""
    substituteInPlace setup.py \
      --replace-fail ', "setuptools_git_ls_files"' ""
  '';

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # import from $out
    mv src/python/compreffor/test .
    rm -r src tools
  '';

  pythonImportsCheck = [ "compreffor" ];

  meta = {
    changelog = "https://github.com/googlefonts/compreffor/releases/tag/${version}";
    description = "CFF table subroutinizer for FontTools";
    mainProgram = "compreffor";
    homepage = "https://github.com/googlefonts/compreffor";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
