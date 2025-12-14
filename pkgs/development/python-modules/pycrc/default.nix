{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pycrc";
  version = "1.21";
  format = "setuptools";

  src = fetchPypi {
    pname = "pythoncrc";
    inherit version;
    hash = "sha256-qqSVNyKM56ATP8YX54AxLX6x4fT4LPRDZbatJw0kTaM=";
  };

  meta = {
    homepage = "https://pypi.org/project/pythoncrc";
    description = "Python libraries for CRC calculations (it supports CRC-16, CRC-32, CRC-CCITT, etc)";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ guibou ];
  };
}
