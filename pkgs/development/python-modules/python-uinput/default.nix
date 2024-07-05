{
  lib,
  buildPythonPackage,
  fetchPypi,
  udev,
}:

buildPythonPackage rec {
  pname = "python-uinput";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hTaXNEtk31U31K4yum+88FFdUakBCRD11QGZWQOLbro=";
  };

  buildInputs = [ udev ];

  NIX_CFLAGS_LINK = "-ludev";

  doCheck = false; # no tests

  meta = with lib; {
    description = "Pythonic API to Linux uinput kernel module";
    homepage = "https://tjjr.fi/sw/python-uinput/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar ];
  };
}
