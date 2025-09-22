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
    pname = "PyCRC";
    inherit version;
    sha256 = "d3b0e788b501f48ae2ff6eeb34652343c9095e4356a65df217ed29b51e4045b6";
  };

  meta = with lib; {
    homepage = "https://github.com/cristianav/PyCRC";
    description = "Python libraries for CRC calculations (it supports CRC-16, CRC-32, CRC-CCITT, etc)";
    license = licenses.gpl3;
    maintainers = with maintainers; [ guibou ];
  };
}
