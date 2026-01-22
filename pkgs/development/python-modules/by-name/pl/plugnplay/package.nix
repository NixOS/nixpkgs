{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "plugnplay";
  version = "0.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "877e2d2500a45aaf31e5175f9f46182088d3e2d64c1c6b9ff6c778ae0ee594c8";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "plugnplay" ];

  meta = {
    description = "Generic plug-in system for python applications";
    homepage = "https://github.com/daltonmatos/plugnplay";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
