{
  lib,
  buildPythonPackage,
  fetchPypi,

  hyperspy,
  exspy,
  scikit-learn,
  scikit-image,
  trackpy,
  numpy,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "particlespy";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EAYoTK7eboIACRBTPybb+KHKcLA04fGzw9lZWKvkIC0=";
  };

  dependencies = [
    hyperspy
    exspy
    scikit-learn
    scikit-image
    trackpy
    numpy
    pyqt5
  ];

  pythonImportsCheck = [ "particlespy.api" ];

  meta = with lib; {
    description = "Package for analysing particles in electron microscopy data sets";
    homepage = "https://epsic-dls.github.io/particlespy/index.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
