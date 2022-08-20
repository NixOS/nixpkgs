{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, ipykernel
, ipywidgets
, pythonOlder
, pytestCheckHook
, pandas
, jinja2
, numpy
, traitlets
}:

buildPythonPackage rec {
  pname = "pydeck";
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  patches = [
    # fixes build with latest setuptools
    (fetchpatch {
      url = "https://github.com/visgl/deck.gl/commit/9e68f73b28aa3bf0f2a887a4d8ccd2dc35677039.patch";
      sha256 = "sha256-YVVoVbVdY5nV+17OwYIs9AwKGyzgKZHi655f4BLcdMU=";
      stripLen = 2;
    })
  ];

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
    jinja2
    numpy
    traitlets
  ];

  meta = with lib; {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.asl20;
  };
}
