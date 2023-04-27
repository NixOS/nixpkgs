{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "codefind";
  version = "0.1.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VmcFA2G/YBolMDGyQ30Wt9gssPoOdW2T5UjHs1zm+RA=";
  };

  buildInputs = [ poetry-core ];

  pythonImportsCheck = [ "codefind" ];

  meta = with lib; {
    description = "Find code objects and their referents";
    homepage = "https://github.com/breuleux/codefind";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
