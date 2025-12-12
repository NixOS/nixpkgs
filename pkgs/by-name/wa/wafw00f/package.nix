{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wafw00f";
  version = "2.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "wafw00f";
    tag = "v${version}";
    hash = "sha256-nJNJAmSjEYKgqVYcNDIL8O6AQzK6DrIN8P4U0s/PWQM=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    requests
    pluginbase
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "wafw00f" ];

  meta = {
    description = "Tool to identify and fingerprint Web Application Firewalls (WAF)";
    homepage = "https://github.com/EnableSecurity/wafw00f";
    changelog = "https://github.com/EnableSecurity/wafw00f/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wafw00f";
  };
}
