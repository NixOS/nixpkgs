{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "environmental-override";
  version = "0.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2mjHn9Hctrlgld+7c8U+lrL3rRes+2DaNLAjZ+IZDe4=";
  };

  # No tests have been written for this library.
  doCheck = false;

  pythonImportsCheck = [ "environmental_override" ];

  meta = {
    description = "Easily configure apps using simple environmental overrides";
    homepage = "https://github.com/coddingtonbear/environmental-override";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nathanruiz ];
  };
}
