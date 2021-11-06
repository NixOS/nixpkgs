{ lib
, buildPythonPackage
, fetchPypi
, ipykernel
, ipywidgets
, jinja2
, numpy
, pandas
, pytestCheckHook
, pytest
, pythonOlder
, traitlets
}:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.7.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bmx5q1mpdp2rx89qp1bd8b6s8a5l6zn5jyp4xny243mkz4h2xlh";
  };

  propagatedBuildInputs =  [
    ipykernel
    ipywidgets
    jinja2
    numpy
    traitlets
  ];

  checkInputs =  [
    pytestCheckHook
    pandas
  ];

  disabledTests = [
    # touches network
    "test_nbconvert"
  ];

  pythonImportsCheck = [
    "pydeck"
  ];

  meta = with lib; {
    description = "Python bindings for spatial visualizations with deck.gl";
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    license = licenses.asl20;
    maintainers = with maintainers; [ nphilou ];
  };
}
