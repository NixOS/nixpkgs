{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "wafw00f";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = "wafw00f";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vGTqgvAVO6fbgRN5V5HhlKFrI9Z2XZaAjI1L19RIi9U=";
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
    changelog = "https://github.com/EnableSecurity/wafw00f/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "wafw00f";
  };
})
