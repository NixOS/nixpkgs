{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycoolmasternet-async";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pycoolmasternet-async";
    tag = "v${version}";
    hash = "sha256-n7P4R9gYfTSgDETWEeuhzbpt1CXbD8jXgbCXrQmsKz0=";
  };

  build-system = [ setuptools ];

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
