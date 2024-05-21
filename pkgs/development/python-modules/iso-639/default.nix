{ lib, fetchPypi, buildPythonPackage, setuptools }:

buildPythonPackage rec {
  pname = "iso-639";
  version = "0.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc9cd4b880b898d774c47fe9775167404af8a85dd889d58f9008035109acce49";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://github.com/noumar/iso639";
    description = "ISO 639 library for Python";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ zraexy ];
  };
}
