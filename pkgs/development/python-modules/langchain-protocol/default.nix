{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-protocol";
  version = "0.0.19";
  pyproject = true;
  __structuredAttrs = true;

  # Not available vis Github yet; required by langchain-core
  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "agent-protocol";
    tag = "langchain-protocol==${finalAttrs.version}";
    hash = "sha256-RiTuadwE3IMhlsFzEZkVlIKMU8/c9uTTDWrXpptriGI=";
  };

  sourceRoot = "${finalAttrs.src.name}/streaming/py";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling>=1.26,<1.30" "hatchling"
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "langchain_protocol"
  ];

  meta = {
    description = "Python bindings for the LangChain agent streaming protocol";
    homepage = "https://pypi.org/project/langchain-protocol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
