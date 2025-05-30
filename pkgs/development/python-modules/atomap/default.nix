{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  scipy,
  numpy,
  h5py,
  matplotlib,
  scikit-learn,
  scikit-image,
  hyperspy,
  ase,
  numba,
  exspy,
}:

buildPythonPackage rec {
  pname = "atomap";
  version = "0.4.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1eQoNTXx8tpofuSqX47t+1xeVwhzrE9S5GsQzwvuk3U=";
  };

  buildInputs = [
    setuptools
  ];

  dependencies = [
    scipy
    numpy
    h5py
    matplotlib
    scikit-learn
    scikit-image
    hyperspy
    ase
    numba
    exspy
  ];

  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "atomap.api" ];

  meta = with lib; {
    description = "Library for analysing atomic resolution images";
    homepage = "https://atomap.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
