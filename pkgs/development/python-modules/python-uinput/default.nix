{ lib
, buildPythonPackage
, fetchPypi
, udev
}:

buildPythonPackage rec {
  pname = "python-uinput";
  version = "0.11.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "033zqiypjz0nigav6vz0s57pbzikvds55mxphrdpkdbpdikjnfcr";
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
