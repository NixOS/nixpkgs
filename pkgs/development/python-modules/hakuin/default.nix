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
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pruzko";
    repo = "hakuin";
    tag = version;
    hash = "sha256-97nh+woUsCXcoO2i5KprCwJiE24V3mg91qcNgy7bpgg=";
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
