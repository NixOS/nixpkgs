{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "ovld";
  version = "0.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+JGGNsJAopNRdUBoAZRNQxSCNxCzr71ajbPnnNk5HEI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  buildInputs = [ poetry-core ];

  pythonImportsCheck = [ "ovld" ];

  meta = with lib; {
    description = "Advanced multiple dispatch for Python functions";
    homepage = "https://github.com/breuleux/ovld";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
