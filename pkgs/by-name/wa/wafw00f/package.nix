{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wafw00f";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "wafw00f";
    rev = "refs/tags/v${version}";
    hash = "sha256-wJZ1/aRMFpE6Q5YAtGxXwxe2G9H/de+l3l0C5rwEWA8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    pluginbase
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "wafw00f" ];

  meta = with lib; {
    description = "Tool to identify and fingerprint Web Application Firewalls (WAF)";
    homepage = "https://github.com/EnableSecurity/wafw00f";
    changelog = "https://github.com/EnableSecurity/wafw00f/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "wafw00f";
  };
}
