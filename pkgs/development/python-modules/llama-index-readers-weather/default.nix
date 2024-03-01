{ lib
, buildPythonPackage
, fetchFromGitHub
, llama-index-core
, poetry-core
, pyowm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "llama-index-readers-weather";
  version = "0.1.4";

  inherit (llama-index-core) src meta;

  pyproject = true;

  sourceRoot = "${src.name}/llama-index-integrations/readers/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
    pyowm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "llama_index.readers.weather"
  ];
}
