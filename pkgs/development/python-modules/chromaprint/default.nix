{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, m2r
}:

buildPythonPackage rec {
  pname = "chromaprint";
  version = "0.5";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d4M+ieNQpIXcnEH1WyIWnTYZe3P+Y58W0uz1uYPwLQE=";
  };

  buildInputs = [ m2r ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "chromaprint" ];

  meta = with lib; {
    description = "Facilitate effortless color terminal output";
    homepage = "https://pypi.org/project/${pname}/";
    license = licenses.mit;
    maintainers = with maintainers; [ dschrempf peterhoeg ];
  };
}
