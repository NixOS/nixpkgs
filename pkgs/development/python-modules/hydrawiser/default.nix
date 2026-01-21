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
    sha256 = "161hazlpvd71xcl2ja86560wm5lnrjv210ki3ji37l6c6gwmhjdj";
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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
