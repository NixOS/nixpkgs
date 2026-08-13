{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  defusedxml,
  requests,
  sphinx,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "pdfservices-sdk";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adobe";
    repo = "pdfservices-python-sdk";
    tag = "v${version}";
    hash = "sha256-m2k+IS+M8UrdrpLnk2OwRolAVq73StMY1WnxzOujBIM=";
  };

  pythonRelaxDeps = true;

  build-system = [
    setuptools
  ];

  dependencies = [
    defusedxml
    requests
    sphinx
    sphinx-rtd-theme
  ];

  pythonImportsCheck = [
    "adobe.pdfservices"
  ];

  meta = {
    description = "Adobe PDFServices Python SDK";
    homepage = "https://github.com/adobe/pdfservices-python-sdk";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ hhr2020 ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
