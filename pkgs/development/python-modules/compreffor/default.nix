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
  version = "0.5.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-icE9GDf5SD/gmqZrGe30SQ7ghColye3VIytSXaI/EA4=";
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

  meta = with lib; {
    changelog = "https://github.com/googlefonts/compreffor/releases/tag/${version}";
    description = "CFF table subroutinizer for FontTools";
    mainProgram = "compreffor";
    homepage = "https://github.com/googlefonts/compreffor";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
