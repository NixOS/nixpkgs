{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "configupdater";
  version = "3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "ConfigUpdater";
    hash = "sha256-n9rFODHBsGKSm/OYtkm4fKMOfxpzXz+/SCBygEEGMGs=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "configupdater" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = with lib; {
    description = "Parser like ConfigParser but for updating configuration files";
    homepage = "https://configupdater.readthedocs.io/en/latest/";
    license = with licenses; [
      mit
      psfl
    ];
    maintainers = with maintainers; [ ris ];
  };
}
