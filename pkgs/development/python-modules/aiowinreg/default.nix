{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  prompt-toolkit,
  pythonOlder,
  setuptools,
  winacl,
}:

buildPythonPackage rec {
  pname = "aiowinreg";
  version = "0.0.13";
  pyproject = true;

  disabled = pythonOlder "3.6";

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

<<<<<<< HEAD
  meta = {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    changelog = "https://github.com/skelsec/aiowinreg/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    changelog = "https://github.com/skelsec/aiowinreg/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "awinreg";
  };
}
