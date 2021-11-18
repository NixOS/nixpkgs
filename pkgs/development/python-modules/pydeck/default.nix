{ lib, buildPythonPackage, fetchPypi, ipykernel, ipywidgets, pythonOlder, pytestCheckHook, pandas }:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.7.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zi0gqzd0byj16ja74m2dm99a1hmrlhk26y0x7am07vb1d8lvvsy";
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
