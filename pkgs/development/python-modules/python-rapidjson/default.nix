{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rapidjson,
  pytestCheckHook,
  pytz,
  setuptools,
  substituteAll,
}:

buildPythonPackage rec {
  version = "1.20";
  pname = "python-rapidjson";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-rapidjson";
    repo = "python-rapidjson";
    rev = "refs/tags/v${version}";
    hash = "sha256-xIswmHQMl5pAqvcTNqeuO3P6MynKt3ahzUgGQroaqmw=";
  };

  patches = [
    (substituteAll {
      src = ./rapidjson-include-dir.patch;
      rapidjson = lib.getDev rapidjson;
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  disabledTestPaths = [ "benchmarks" ];

  meta = with lib; {
    changelog = "https://github.com/python-rapidjson/python-rapidjson/blob/${src.rev}/CHANGES.rst";
    homepage = "https://github.com/python-rapidjson/python-rapidjson";
    description = "Python wrapper around rapidjson";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
