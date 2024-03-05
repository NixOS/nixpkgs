{ lib
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "pymorphy3-dicts-ru";
  version = "2.4.417150.4580142";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Oas3nUypBbr+1Q9a/Do95vlkNgV3b7yrxNMIjU7TgrA=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymorphy3_dicts_ru" ];

  meta = with lib; {
    description = "Russian dictionaries for pymorphy3";
    homepage = "https://github.com/no-plagiarism/pymorphy3-dicts";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
  };
}
