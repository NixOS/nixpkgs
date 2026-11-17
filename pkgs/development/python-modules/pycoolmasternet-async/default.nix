{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    tag = "v${version}";
    hash = "sha256-4UZdFQ/4+hHAv4zu5A4w/Lcnbtdul8cDvL3YYUgJ8AE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "pycoolmasternet_async" ];

  meta = {
    description = "Python library to control CoolMasterNet HVAC bridges over asyncio";
    homepage = "https://github.com/OnFreund/pycoolmasternet-async";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
