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
  version = "1.1.79";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bunsly";
    repo = "JobSpy";
    tag = "v${version}";
    hash = "sha256-09UVZUcBNyKLSbqHOctct7dRJhmRdS6wb5hjMI3YWdg=";
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
