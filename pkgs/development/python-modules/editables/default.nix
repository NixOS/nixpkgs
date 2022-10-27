{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "editables";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FnUk43c1jtHxN05hwmjw16S/fb0EbGVve0EM3hYWGxo=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  # Tests not included in archive.
  doCheck = false;

  pythonImportsCheck = [ "editables" ];

  meta = with lib; {
    description = "Editable installations";
    maintainers = with maintainers; [ ];
    homepage = "https://github.com/pfmoore/editables";
    license = licenses.mit;
  };
}
