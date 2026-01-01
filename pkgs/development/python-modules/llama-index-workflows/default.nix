{
  lib,
  buildPythonPackage,
  eval-type-backport,
  fetchPypi,
<<<<<<< HEAD
  uv-build,
=======
  hatchling,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  llama-index-instrumentation,
  pydantic,
}:

buildPythonPackage rec {
  pname = "llama-index-workflows";
<<<<<<< HEAD
  version = "2.11.5";
=======
  version = "2.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_workflows";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-3vumxRaanJhv4G3Z8+5eGmzF9Yx3ZgXARYuqClXwdkM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.10,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];
=======
    hash = "sha256-BG9BRshG9UFl91B8XkZsL1lINJ9UElyUUFY0OgC/pCs=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [ hatchling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = [
    eval-type-backport
    llama-index-instrumentation
    pydantic
  ];

  pythonImportsCheck = [ "workflows" ];

  meta = {
    description = "Event-driven, async-first, step-based way to control the execution flow of AI applications like Agents";
    homepage = "https://pypi.org/project/llama-index-workflows/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
