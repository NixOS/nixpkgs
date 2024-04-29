{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  zlib,
  ...
}:
buildPythonPackage rec {
  pname = "libfvde-python";
  version = "20240113";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GN9Je1s2w2o/ps9zZaZgajJiuHWd8vbAmHpqRfBdssg=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyfvde" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libfvde/releases/tag/${version}";
    description = "Python bindings module for libfvde";
    downloadPage = "https://github.com/libyal/libfvde/releases";
    homepage = "https://github.com/libyal/libfvde";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
