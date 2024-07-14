{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  chmlib,
}:

buildPythonPackage rec {
  pname = "pychm";
  version = "0.8.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JmBv7B4wz3UGx6+pQ0YMMejayH81t/F49DdXTWVM9nI=";
  };

  buildInputs = [ chmlib ];

  pythonImportsCheck = [ "chm" ];

  meta = with lib; {
    description = "Library to manipulate Microsoft HTML Help (CHM) files";
    homepage = "https://github.com/dottedmag/pychm";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexshpilkin ];
  };
}
