{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "hydrawiser";
  version = "0.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ptcryan";
    repo = pname;
    rev = "v${version}";
    sha256 = "161hazlpvd71xcl2ja86560wm5lnrjv210ki3ji37l6c6gwmhjdj";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov
    pytestCheckHook
    requests
    requests-mock
  ];

  pythonImportsCheck = [ "hydrawiser" ];

  meta = with lib; {
    description = "Python library for Hydrawise API";
    homepage = "https://github.com/ptcryan/hydrawiser";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
