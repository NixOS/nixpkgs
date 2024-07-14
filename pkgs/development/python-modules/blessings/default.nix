{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  nose,
}:

buildPythonPackage rec {
  pname = "blessings";
  version = "1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mOWFTYBfUKW1isIzNBGwSCUWqCEPI/QzCLrrWNd8FX0=";
  };

  # 4 failing tests, 2to3
  doCheck = false;

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/erikrose/blessings";
    description = "Thin, practical wrapper around terminal coloring, styling, and positioning";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar ];
  };
}
