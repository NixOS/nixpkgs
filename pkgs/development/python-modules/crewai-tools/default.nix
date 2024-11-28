{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  pydantic,
  pytest,
  lancedb,
  openai,
  chromadb,
  pytube,
  requests,
  beautifulsoup4,
  selenium,
  docx2txt,
  docker,
  embedchain,
}:

buildPythonPackage {
  pname = "crewai-tools";
  version = "0.14.0";

  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "crewAIInc";
    repo = "crewAI-tools";
    # Note: There are no tagged releases yet so we just use the latest revision
    rev = "03f77f0"; # "refs/tags/${version}";
    hash = "sha256-sxb6nBVoTTOAOs11uwDbtgH9cJ7yc7gwqxhoftgdVMU=";
  };

  dependencies = [
    pydantic
    pytest
    lancedb
    openai
    chromadb
    pytube
    requests
    beautifulsoup4
    selenium
    docx2txt
    docker
    embedchain
  ];

  pythonRemoveDeps = [
    # This is really only a development dependency
    "pyright"
  ];

  build-system = [ hatchling ];

  enableParallelBuilding = true;

  doCheck = true;

  pythonImportsCheck = [ "crewai[tools]" ];

  meta = {
    description = "Library for building tools for CrewAI, and a collection of pre-built tools.";
    # Note: There are no releases yet so the closest thing to a download page is the github page
    downloadPage = "https://github.com/crewAIInc/crewAI-tools";
    homepage = "https://www.crewai.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
