{ lib, buildPythonPackage, fetchPypi, ipykernel, ipywidgets, pythonOlder, pytestCheckHook, pandas }:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.7.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "907601c99f7510e16d27d7cb62bfa145216d166a2b5c9c50cfe2b65b032ebd2e";
  };

  pythonImportsCheck = [ "pydeck" ];

  checkInputs = [ pytestCheckHook pandas ];
  # tries to start a jupyter server
  disabledTests = [ "test_nbconvert" ];

  propagatedBuildInputs = [
    ipykernel
    ipywidgets
  ];

  meta = with lib; {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.asl20;
  };
}
