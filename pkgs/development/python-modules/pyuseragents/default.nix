{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyuseragents";
  version = "1.0.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Animenosekai";
    repo = "useragents";
    rev = "v${version}";
    sha256 = "D7Qs3vsfkRH2FDkbfakrR+FfWzQFiOCQM7q9AdJavyU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "test.py" ];
  pythonImportsCheck = [ "pyuseragents" ];

  meta = {
    description = "Giving you a random User-Agent Header";
    homepage = "https://github.com/Animenosekai/useragents";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
