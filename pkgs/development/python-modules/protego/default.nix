{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "protego";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "Protego";
    hash = "sha256-k6XmYrYTmaDh8gijJPLG6pWyPuOebL8sliRtpKZWwvY=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "protego" ];

  meta = with lib; {
    description = "Module to parse robots.txt files with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    changelog = "https://github.com/scrapy/protego/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
