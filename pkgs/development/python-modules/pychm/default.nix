{
  lib,
  buildPythonPackage,
  fetchPypi,
  chmlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "pychm";
  version = "0.8.6";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JmBv7B4wz3UGx6+pQ0YMMejayH81t/F49DdXTWVM9nI=";
  };

  buildInputs = [ chmlib ];

  pythonImportsCheck = [ "chm" ];

  meta = {
    description = "Library to manipulate Microsoft HTML Help (CHM) files";
    homepage = "https://github.com/dottedmag/pychm";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ alexshpilkin ];
  };
})
