{
  lib,
  buildPythonPackage,
  fetchPypi,
  beniget,
  frilouz,
  gast,
  nbconvert,
  nbformat,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "memestra";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6shwf9BoDfZMy0itP8esNP4ov6fw6LJpO3Y5ZahwDZw=";
  };

  propagatedBuildInputs = [
    gast
    beniget
    frilouz
    nbconvert
    nbformat
    pyyaml
  ];

  # Tests are not detected and so the checkPhase fails
  doCheck = false;

  pythonImportsCheck = [ "memestra" ];

  meta = with lib; {
    description = "A linter that tracks reference to deprecated functions.";
    homepage = "https://github.com/QuantStack/memestra";
    license = licenses.bsd3;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
