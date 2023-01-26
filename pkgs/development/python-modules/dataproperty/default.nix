{ buildPythonPackage
, mbstrdecoder
, typepy

, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "dataproperty";
  version = "0.55.0";

  propagatedBuildInputs = [ mbstrdecoder typepy ];
  doCheck = false;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ODSrKZ8M/ni9r2gkVIKWaKkdr+3AVi4INkEKJ+cmb44=";
  };

  meta = with lib; {
    homepage = "https://github.com/thombashi/dataproperty";
    description = "A Python library for extract property from data";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
