{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, dataclasses
, ovld
}:

buildPythonPackage rec {
  pname = "hrepr";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wRPGYabGk6UXj5JoUWWnmf/bkwgL71EPqTminxZ3uxg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  buildInputs = [ poetry-core ];
  propagatedBuildInputs = [ ovld ];

  pythonImportsCheck = [ "hrepr" ];

  meta = with lib; {
    description = "Advanced multiple dispatch for Python functions";
    homepage = "https://github.com/breuleux/hrepr";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
