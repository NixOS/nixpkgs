{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-protocol";
  version = "0.0.15";
  pyproject = true;

  # Not available vis Github yet; required by langchain-core
  src = fetchPypi {
    pname = "langchain_protocol";
    inherit (finalAttrs) version;
    hash = "sha256-mrLRHuc5RHVPEOA35xcJjTpnlvDlivqcrdphVOdlWt4=";
  };

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
