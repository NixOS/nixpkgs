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
  pname = "libewf-python";
  version = "20231119";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-35hPmLSVZnAQTputkeputePD2pVwYOt7qerbAe8CE4I=";
  };

  build-system = [ setuptools ];

  buildInputs = [ zlib ];

  disabled = pythonOlder "3.7";

  pythonImportsCheck = [ "pyewf" ];

  meta = with lib; {
    changelog = "https://github.com/libyal/libewf/releases/tag/${version}";
    description = "Python bindings module for libewf";
    downloadPage = "https://github.com/libyal/libewf/releases";
    homepage = "https://github.com/libyal/libewf";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
