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
  version = "0.0.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-RGGavZ3Obe5rjm5HX+L96Pg/9bQn7OvgXJ++DyXxGk0=";
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
