{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "brottsplatskartan";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrillux";
    repo = "brottsplatskartan";
    rev = version;
    sha256 = "07iwmnchvpw156j23yfccg4c32izbwm8b02bjr1xgmcwzbq21ks9";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "brottsplatskartan" ];

  meta = {
    description = "Python API wrapper for brottsplatskartan.se";
    homepage = "https://github.com/chrillux/brottsplatskartan";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
