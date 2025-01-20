{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  interegular,
  cloudpickle,
  datasets,
  diskcache,
  joblib,
  jsonschema,
  pyairports,
  pycountry,
  pydantic,
  lark,
  nest-asyncio,
  numba,
  scipy,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = pname;
    tag = version;
    hash = "sha256-HuJqLbBHyoyY5ChQQi+9ftvPjLuh63Guk2w6KSZxq6s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    interegular
    cloudpickle
    datasets
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
    pycountry
    pyairports
  ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    python3 -c 'import outlines'
  '';

  meta = with lib; {
    description = "Structured text generation";
    homepage = "https://github.com/outlines-dev/outlines";
    license = licenses.asl20;
    maintainers = with maintainers; [ lach ];
  };
}
