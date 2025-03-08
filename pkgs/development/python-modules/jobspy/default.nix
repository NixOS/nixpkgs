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
  version = "1.1.77";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bunsly";
    repo = "JobSpy";
    tag = "v${version}";
    hash = "sha256-/cZmUrWZutSRs5tkEEdyUiTBp1zW1baYcymXzo9NO7M=";
  };

  pythonRelaxDeps = [
    "numpy"
    "markdownify"
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
