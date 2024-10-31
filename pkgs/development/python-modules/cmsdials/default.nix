{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  requests,
  typing-extensions,
  pandas,
  tqdm,
}:

buildPythonPackage rec {
  pname = "cmsdials";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cms-DQM";
    repo = "dials-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-tV802rz8V9zkjxOoGDXuYGD9FNWjdPb3Grp2khwxC9I=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pydantic
    requests
    typing-extensions
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    tqdm = [ tqdm ];
  };

  pythonRelaxDeps = [
    # pydantic = "<2, >=1"pydantic = "<2, >=1"
    "pydantic"
    # typing-extensions = "<4.6.0, >=3.6.6"
    "typing-extensions"
  ];

  pythonImportsCheck = [ "cmsdials" ];

  meta = with lib; {
    description = "Python API client interface to CMS DIALS service";
    homepage = "https://github.com/cms-DQM/dials-py";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
