{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "hydrawiser";
  version = "0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ptcryan";
    repo = "hydrawiser";
    rev = "v${version}";
    hash = "sha256-sklY+TPM0DOiHHGCILbMlpbKgSkGKSko6+G0felXMJg=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    requests
    requests-mock
  ];

  pythonImportsCheck = [ "hydrawiser" ];

  meta = {
    description = "Python library for Hydrawise API";
    homepage = "https://github.com/ptcryan/hydrawiser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
