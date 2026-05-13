{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  numpy,
  pandas,
  pydantic,
  regex,
  requests,
  markdownify,
  tls-client,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "jobspy";
  version = "1.1.82";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bunsly";
    repo = "JobSpy";
    tag = version;
    hash = "sha256-iLtUIM7QBIl6UAcb1RvKt2uw5gHEIQXuo4z/OQu86wM=";
  };

  pythonRelaxDeps = [
    "numpy"
    "markdownify"
    "regex"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    numpy
    pandas
    pydantic
    regex
    requests
    markdownify
    tls-client
    beautifulsoup4
  ];

  pythonImportsCheck = [ "jobspy" ];

  # no package tests because they all require networking/polling

  meta = {
    description = "Jobs scraper library for job sites";
    downloadPage = "https://github.com/Bunsly/JobSpy";
    homepage = "https://github.com/Bunsly/JobSpy";
    changelog = "https://github.com/Bunsly/JobSpy/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
