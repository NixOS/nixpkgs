{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "metar";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "python-metar";
    repo = "python-metar";
    rev = "v${version}";
    sha256 = "019vfq9191cdvvq1afdcdgdgbzpj7wq6pz9li8ggim71azjnv5nn";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "metar" ];

  meta = with lib; {
    description = "Python parser for coded METAR weather reports";
    homepage = "https://github.com/python-metar/python-metar";
    license = with licenses; [ bsd1 ];
    maintainers = with maintainers; [ fab ];
  };
}
