{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wafw00f";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "wafw00f";
    tag = "v${version}";
    hash = "sha256-47lzFPMyAJTtreGGazFWUYiu9e9Q1D3QYsrQbwyaQME=";
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
