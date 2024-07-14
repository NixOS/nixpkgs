{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
}:

buildPythonPackage rec {
  pname = "python-wifi";
  version = "0.6.1";
  format = "setuptools";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "tar.bz2";
    hash = "sha256-e/9q+8A7HLE/mH5c87WXuIIaG4bls0GCQG2YZX8bLJE=";
  };

  meta = with lib; {
    description = "Read & write wireless card capabilities using the Linux Wireless Extensions";
    homepage = "http://pythonwifi.tuxfamily.org/";
    # From the README: "pythonwifi is licensed under LGPLv2+, however, the
    # examples (e.g. iwconfig.py and iwlist.py) are licensed under GPLv2+."
    license = with licenses; [
      lgpl2Plus
      gpl2Plus
    ];
  };
}
