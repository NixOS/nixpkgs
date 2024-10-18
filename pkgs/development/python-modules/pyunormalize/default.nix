{
  lib,
  pythonPackages,
  buildPythonPackage,
  setuptools,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pyunormalize";
  version = "15.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z0qHRRoPHLdpEaqX9DL0V54fVkovDITOSIxzpzkBtsE=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pythonPackages.pytestCheckHook ];

  pythonImportsCheck = [ "pyunormalize" ];

  meta = with lib; {
    description = "Unicode normalization forms (NFC, NFKC, NFD, NFKD)";
    homepage = "https://github.com/mlodewijck/pyunormalize/";
    license = licenses.mit;
    maintainers = with maintainers; [ hellwolf ];
  };
}
