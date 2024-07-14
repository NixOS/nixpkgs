{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyownet";
  version = "0.10.0.post1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ty+kRxwvgGs1CQvcbAkjBcbt7T/zc2+LWG01vbFX3mI=";
  };

  postPatch = ''
    sed -i '/use_2to3/d' setup.py
  '';

  # tests access network
  doCheck = false;

  pythonImportsCheck = [ "pyownet.protocol" ];

  meta = with lib; {
    description = "Python OWFS client library (owserver protocol)";
    homepage = "https://github.com/miccoli/pyownet";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
