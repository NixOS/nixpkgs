{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "editables";
  version = "0.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MJYn2bXErcDmaNjG+nusG6fIxdQVwtJ/YPCB+OgNHeI=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
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
