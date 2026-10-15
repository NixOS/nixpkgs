{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rapidjson,
  pytestCheckHook,
  pytz,
  setuptools,
  replaceVars,
}:

buildPythonPackage rec {
  version = "1.25";
  pname = "python-rapidjson";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-rapidjson";
    repo = "python-rapidjson";
    tag = "v${version}";
    hash = "sha256-4KIC7hXZBvdKZc/p7OQyrxzIRnpZvMDrLyWsPfPwm5I=";
  };

  patches = [
    (replaceVars ./rapidjson-include-dir.patch {
      rapidjson = lib.getDev rapidjson;
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTestPaths = [ "benchmarks" ];

  meta = {
    changelog = "https://github.com/python-rapidjson/python-rapidjson/blob/${src.tag}/CHANGES.rst";
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
