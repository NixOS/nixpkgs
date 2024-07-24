{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pandocfilters,
  psutil,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pandoc-xnos";
  version = "2.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    hash = "sha256-beiGvN0DS6s8wFjcDKozDuwAM2OApX3lTRaUDRUqLeU=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonRelaxDeps = [ "psutil" ];

  propagatedBuildInputs = [
    pandocfilters
    psutil
  ];

  pythonImportsCheck = [ "pandocxnos" ];

  # tests need some patching
  doCheck = false;

  meta = with lib; {
    description = "Pandoc filter suite providing facilities for cross-referencing in markdown documents";
    mainProgram = "pandoc-xnos";
    homepage = "https://github.com/tomduck/pandoc-xnos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
  };
}
