{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "dfdatetime";
  version = "20240330";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vRKhR+/pPLWhzo5s1sXK/oOIu+HZmjEgZflICnXsiJ0=";
  };

  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  pythonImportsCheck = [ pname ];

  meta = with lib; {
    changelog = "https://github.com/log2timeline/dfdatetime/releases/tag/${version}";
    description = "dfDateTime, or Digital Forensics date and time, provides date and time objects to preserve accuracy and precision.";
    homepage = "https://github.com/log2timeline/dfdatetime";
    downloadPage = "https://github.com/log2timeline/dfdatetime/releases";
    license = licenses.asl20;
    maintainers = [ maintainers.jayrovacsek ];
  };
}
