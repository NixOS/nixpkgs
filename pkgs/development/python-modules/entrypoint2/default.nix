{ lib, buildPythonPackage, fetchPypi, EasyProcess, pathpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "entrypoint2";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z+kG9q2VjYP0i07ewo192CZw6SYZiPa0prY6vJ+zvlY=";
  };

  pythonImportsCheck = [ "entrypoint2" ];

  checkInputs = [ EasyProcess pathpy pytestCheckHook ];

  meta = with lib; {
    description = "Easy to use command-line interface for python modules";
    homepage = "https://github.com/ponty/entrypoint2/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ austinbutler ];
  };
}
