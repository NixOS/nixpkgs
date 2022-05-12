{ buildPythonPackage
, fetchFromGitHub
, lib
, pandocfilters
, psutil
}:

buildPythonPackage rec {
  pname = "pandoc-xnos";
  version = "2.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tomduck";
    repo = pname;
    rev = version;
    sha256 = "sha256-beiGvN0DS6s8wFjcDKozDuwAM2OApX3lTRaUDRUqLeU=";
  };

  propagatedBuildInputs = [ pandocfilters psutil ];

  pythonImportsCheck = [ "pandocxnos" ];

  meta = with lib; {
    description = "Pandoc filter suite providing facilities for cross-referencing in markdown documents";
    homepage = "https://github.com/tomduck/pandoc-xnos";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ppenguin ];
  };
}
