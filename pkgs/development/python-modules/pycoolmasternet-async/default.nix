{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    rev = "refs/tags/v${version}";
    hash = "sha256-MfWWy4C/G2w0Zb4C6iYbcfKciFtWctZ63K8lWaHuSnQ=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pycoolmasternet_async" ];

  meta = with lib; {
    description = "Python library to control CoolMasterNet HVAC bridges over asyncio";
    homepage = "https://github.com/OnFreund/pycoolmasternet-async";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
