{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  nltk,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hakuin";
  version = "0-unstable-2024-03-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pruzko";
    repo = "hakuin";
    rev = "3b7b76dcbfb8ab2b98e6dee08df02158327af772";
    hash = "sha256-tRjo9a0ZCBjKxbXTkiKFzfL4pL5awF5vXmsJlYxwoIw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    jinja2
    nltk
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "hakuin" ];

  meta = with lib; {
    description = "Blind SQL Injection optimization and automation framework";
    homepage = "https://github.com/pruzko/hakuin";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
