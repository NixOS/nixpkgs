{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pySmartDL";
  version = "1.3.4";
  src = fetchFromGitHub ({
    owner = "iTaybb";
    repo = pname;
    rev = "b93df794e1e60017c42d9520ac097b6fd38c2e8b";
    hash = "sha256-Etyv3xCB1cGozWDsskygwcTHJfC+V5hvqBNQAF8SIMM=";
  });

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/iTaybb/pySmartDL";
    description = "A Smart Download Manager for Python";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ WeebSorceress ];
  };
}
