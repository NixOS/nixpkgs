{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  dask,
  python-dateutil,
  numpy,
  pint,
  python-box,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "rosettasciio";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-USkXV4eeOv42yBLpWPLOl48sQZeUtGnU3KCcz9jhibk=";
  };

  disabled = pythonOlder "3.9";

  dependencies = [
    dask
    python-dateutil
    numpy
    pint
    python-box
    pyyaml
  ];

  pythonImportsCheck = [ "rsciio" ];

  meta = with lib; {
    description = "Python library for reading and writing a wide variety of scientific data formats";
    homepage = "https://hyperspy.org/rosettasciio/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      hcenge
      classic-ally
    ];
  };
}
