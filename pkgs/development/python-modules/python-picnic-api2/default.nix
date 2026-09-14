{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pydantic,
  pytestCheckHook,
  pythonAtLeast,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-picnic-api2";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "codesalatdev";
    repo = "python-picnic-api";
    tag = "v${version}";
    hash = "sha256-Ft/OEXkiXfsX1Kyi47PzycHk19jEIwYqyG+KP8q8x0I=";
  };

  postPatch = lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace tests/test_session.py \
      --replace-fail '"Accept-Encoding": "gzip, deflate",' '"Accept-Encoding": "gzip, deflate, zstd",'
  '';

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "python_picnic_api2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # tests access the actual API
    "integration_tests"
  ];

  meta = {
    changelog = "https://github.com/codesalatdev/python-picnic-api/releases/tag/${src.tag}";
    description = "Fork of the Unofficial Python wrapper for the Picnic API";
    homepage = "https://github.com/codesalatdev/python-picnic-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
