{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  rich,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "enrich";
  version = "1.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ciqw0pMd/4lHASYC0SNNKj7gAtmjVbXXC+a/VGYAiJM=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ rich ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = [
    # console output order is racy
    "test_rich_console_ex"
  ];

  pythonImportsCheck = [ "enrich" ];

  meta = with lib; {
    description = "Enrich adds few missing features to the wonderful rich library";
    homepage = "https://github.com/pycontribs/enrich";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
