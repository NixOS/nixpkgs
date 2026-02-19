{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  nltk,
}:

buildPythonPackage rec {
  pname = "hakuin";
  version = "0.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pruzko";
    repo = "hakuin";
    tag = version;
    hash = "sha256-l5YnGRPUZUQqOaRvQd4l4eowWGpuPBignjkDDT9q7fg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    jinja2
    nltk
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "hakuin" ];

  meta = {
    description = "Blind SQL Injection optimization and automation framework";
    homepage = "https://github.com/pruzko/hakuin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
