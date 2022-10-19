{ lib
, buildPythonPackage
, fetchPypi
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3Y5wGE0q+KGV1WjgwsPMGX8MlMKkd0dUEeXql4xnsn0=";
  };

  propagatedBuildInputs = [
    cython
  ];

  # TODO: The test doesn't work out of the box.
  doCheck = false;

  pythonImportsCheck = [ "rpack" ];

  meta = with lib; {
    homepage = "https://github.com/orkohunter/keep";
    description = "Rectangle packing program";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
