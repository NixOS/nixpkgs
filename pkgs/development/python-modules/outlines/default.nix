{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, interegular
, cloudpickle
, diskcache
, joblib
, jsonschema
, pydantic
, lark
, nest-asyncio
, numba
, scipy
, torch
, transformers
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "0.0.34";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iIlthrhmCm3n0PwUSa1n7CL04sDc1Cs+rVboPY4nH78=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    interegular
    cloudpickle
    diskcache
    joblib
    jsonschema
    pydantic
    lark
    nest-asyncio
    numba
    scipy
    torch
    transformers
  ];

  pythonImportsCheck = [
    "outlines"
  ];

  meta = with lib; {
    description = "Structured text generation";
    homepage = "https://github.com/outlines-dev/outlines";
    license = licenses.asl20;
    maintainers = with maintainers; [ lach ];
  };
}
