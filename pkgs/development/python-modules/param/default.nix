{ lib
, buildPythonPackage
, fetchPypi
, flake8
, nose
}:

buildPythonPackage rec {
  pname = "param";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NdAoHI47623UafRv8LkXdSpUvtlNGwxWc0bHbQ/1nEo=";
  };

  checkInputs = [ flake8 nose ];

  # tests not included with pypi release
  doCheck = false;

  pythonImportsCheck = [
    "param"
  ];

  meta = with lib; {
    description = "Declarative Python programming using Parameters";
    homepage = "https://github.com/pyviz/param";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
