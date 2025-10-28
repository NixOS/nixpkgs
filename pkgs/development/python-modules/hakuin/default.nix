{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  nltk,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "hakuin";
  version = "0.1.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

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

  meta = with lib; {
    description = "Blind SQL Injection optimization and automation framework";
    homepage = "https://github.com/pruzko/hakuin";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
