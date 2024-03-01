{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, llama-index-core
}:

buildPythonPackage rec {
  pname = "llama-index-legacy";

  inherit (llama-index-core) version src meta;

  pyproject = true;

  sourceRoot = "${src.name}/${pname}";

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    llama-index-core
  ];
}
