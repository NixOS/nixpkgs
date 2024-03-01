{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, llama-index-core
}:

buildPythonPackage rec {
  pname = "llama-index-indices-managed-llama-cloud";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/indices/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_index.indices.managed.llama_cloud"
  ];
}
