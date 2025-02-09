{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, pytestCheckHook
, cookiecutter
, datasets
, dill
, fsspec
, huggingface-hub
, importlib-metadata
, multiprocess
, numpy
, packaging
, pandas
, pyarrow
, requests
, responses
, tqdm
, xxhash
}:

buildPythonPackage rec {
  pname = "evaluate";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-axcJg0ZalEd4FOySCiFReKL7wmTCtLaw71YqyLHq8fc=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "responses" ];

  propagatedBuildInputs = [
    cookiecutter
    datasets
    numpy
    dill
    pandas
    requests
    tqdm
    xxhash
    multiprocess
    fsspec
    huggingface-hub
    packaging
    pyarrow
    responses
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # most tests require internet access.
  doCheck = false;

  pythonImportsCheck = [
    "evaluate"
  ];

  meta = with lib; {
    homepage = "https://huggingface.co/docs/evaluate/index";
    description = "Easily evaluate machine learning models and datasets";
    changelog = "https://github.com/huggingface/evaluate/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "evaluate-cli";
  };
}
