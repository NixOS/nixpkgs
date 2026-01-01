{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "netio";
  version = "1.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    tag = "v${version}";
    hash = "sha256-s/X2WGhQXYsbo+ZPpkVSF/vclaThYYNHu0UY0yCnfPA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pyopenssl" ];

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  pythonImportsCheck = [ "Netio" ];

  # Module has no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Module for interacting with NETIO devices";
    mainProgram = "Netio";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${version}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
