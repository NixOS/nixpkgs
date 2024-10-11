{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  beautifulsoup4,
  python-docx,
}:

buildPythonPackage rec {
  pname = "htmldocx";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tLzsiV+G16UP/HEzyiTYXCTzYU2ys30zow2dBGVKVIY=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    beautifulsoup4
    python-docx
  ];

  pythonImportsCheck = [
    "htmldocx"
  ];

  meta = {
    description = "Convert html to docx";
    homepage = "https://pypi.org/project/htmldocx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
