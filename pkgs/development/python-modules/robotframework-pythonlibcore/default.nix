{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, pytest-mockito
, pytestCheckHook
, robotframework
}:

buildPythonPackage rec {
  pname = "robotframework-pythonlibcore";
  version = "4.0.0";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "robotframework";
    repo = "PythonLibCore";
    rev = "v${version}";
    hash = "sha256-86o5Lh9zWo4vUF2186dN7e8tTUu5PIxM/ZukPwNl0S8=";
  };

  patches = [
    (fetchpatch {
      name = "fix-finding-version.patch";
      url = "https://github.com/robotframework/PythonLibCore/commit/84c73979e309f59de057ae6a77725ab0f468b71f.patch";
      hash = "sha256-zrjsNvXpJDLpXql200NV+QGWFLtnRVZTeAjT52dRn2s=";
    })
  ];

  nativeCheckInputs = [
    pytest-mockito
    pytestCheckHook
    robotframework
  ];

  preCheck = ''
    export PYTHONPATH="atest:utest/helpers:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "robotlibcore" ];

  meta = {
    changelog = "https://github.com/robotframework/PythonLibCore/blob/${src.rev}/docs/PythonLibCore-${version}.rst";
    description = "Tools to ease creating larger test libraries for Robot Framework using Python";
    homepage = "https://github.com/robotframework/PythonLibCore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
