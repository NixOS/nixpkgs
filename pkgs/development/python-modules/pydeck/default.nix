{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, ipykernel
, ipywidgets
, jinja2
, jupyter
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, setuptools
, traitlets
, wheel
=======
, fetchpatch
, ipykernel
, ipywidgets
, pythonOlder
, pytestCheckHook
, pandas
, jinja2
, numpy
, traitlets
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pydeck";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B+3egz98/O9nSRJDURlap9zSRmPUkJ/XiY29C2+8Aew=";
  };

  nativeBuildInputs = [
    jinja2
    jupyter
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    jinja2
    numpy
  ];

  passthru.optional-dependencies = {
    carto = [
      # pydeck-carto
    ];
    jupyter = [
      ipykernel
      ipywidgets
      traitlets
    ];
=======
  patches = [
    # fixes build with latest setuptools
    (fetchpatch {
      url = "https://github.com/visgl/deck.gl/commit/9e68f73b28aa3bf0f2a887a4d8ccd2dc35677039.patch";
      hash = "sha256-YVVoVbVdY5nV+17OwYIs9AwKGyzgKZHi655f4BLcdMU=";
      stripLen = 2;
    })
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "907601c99f7510e16d27d7cb62bfa145216d166a2b5c9c50cfe2b65b032ebd2e";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [ "pydeck" ];

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ] ++ passthru.optional-dependencies.jupyter;
=======
  nativeCheckInputs = [ pytestCheckHook pandas ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tries to start a jupyter server
  disabledTests = [ "test_nbconvert" ];

<<<<<<< HEAD
=======
  propagatedBuildInputs = [
    ipykernel
    ipywidgets
    jinja2
    numpy
    traitlets
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "https://github.com/visgl/deck.gl/tree/master/bindings/pydeck";
    description = "Large-scale interactive data visualization in Python";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.asl20;
  };
}
