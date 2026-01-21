{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prompt-toolkit,
  setuptools,
  winacl,
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = "aiowinreg";
    tag = version;
    hash = "sha256-vY5SrGTFH/xsv9k2WciE0xNx9r3W53sxxLGXFX34EuE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    prompt-toolkit
    winacl
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowinreg" ];

  meta = {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    changelog = "https://github.com/skelsec/aiowinreg/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "awinreg";
  };
}
