{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, rx
, varname
}:

buildPythonPackage rec {
  pname = "giving";
  version = "0.3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LdH5zrkrN4LHGGoiYPx64CL/LIk/Cnh7a6vrEYf3Ubw=";
  };

  buildInputs = [ poetry-core ];
  propagatedBuildInputs = [ rx varname ];

  pythonImportsCheck = [ "giving" ];

  meta = with lib; {
    description = "Reactive logging";
    homepage = "https://github.com/breuleux/giving";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
