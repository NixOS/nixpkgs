{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  airportsdata,
  interegular,
  cloudpickle,
  datasets,
  diskcache,
  jinja2,
  jsonschema,
  numpy,
  outlines-core,
  pycountry,
  pydantic,
  lark,
  nest-asyncio,
  referencing,
  requests,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outlines-dev";
    repo = "outlines";
    tag = version;
    hash = "sha256-WmkA+plIouEzleo3yoSxfCjK0E3EfMGQIPl20aIKxl8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    airportsdata
    interegular
    cloudpickle
    datasets
    diskcache
    jinja2
    jsonschema
    outlines-core
    pydantic
    lark
    nest-asyncio
    numpy
    referencing
    requests
    torch
    transformers
    pycountry
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
